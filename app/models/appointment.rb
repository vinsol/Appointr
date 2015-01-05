class Appointment < ActiveRecord::Base
  
  include PgSearch
  include AASM

  aasm(no_direct_assignment: false, column: 'state', whiny_transitions: false) do
    state :approved, :initial => true
    state :cancelled
    state :attended
    state :missed

    event :cancel do
      transitions :from => :approved, :to => :cancelled
      after do
        CustomerMailer.delay.cancel_appointment_notifier(self)
        StaffMailer.delay.cancel_appointment_notifier(self)
      end
    end

    event :attend do
      transitions :from => [:approved, :missed, :attended], :to => :attended
    end

    event :miss do
      transitions :from => [:approved, :missed, :attended], :to => :missed
    end
  end

  #scopes
  scope :past, -> { where('start_at <= ?', Time.current) }
  scope :future, -> { where('start_at >= ?', Time.current) }
  scope :past_or_cancelled, -> { where('state = ? OR start_at <= ?', 'cancelled', Time.current) }
  scope :past_and_not_cancelled, -> { where.not('state = ? OR state = ?', 'cancelled', 'approved').past }
  # [rai] though the below scopes does not seem to be exposed for sql injection but it is always good practice to maintain it.
  # [rai] how could start_at = Time.current is past time
  # [rai] how could start_at = Time.current is future time
  
  # [rai] we need a cancelled and not_cancelled scope and below scope could be like past.cancelled and past.not_cancelled
  pg_search_scope :search_for_admin, :associated_against => {
    :customer => [:name, :email],
    :staff => [:name, :email],
    :service => [:name]
  }

  # Associations
  belongs_to :customer
  belongs_to :staff
  belongs_to :service
  belongs_to :reminder_job, class_name: 'Delayed::Job', foreign_key: 'reminder_job_id'

  # Validations
  validates :service, :customer, :start_at, :duration, presence: true
  validates :start_at, future: true, if: :start_at
  validate :ensure_duration_not_less_than_service_duration, if: [:duration, :service]
  validate :ensure_customer_has_no_prior_appointment_at_same_time, if: :customer
  validate :staff_allotable?, if: :staff
  before_save :assign_staff, unless: :staff

  # Callbacks
  after_create :send_new_appointment_mail_to_customer_and_staff
  after_update :send_edit_appointment_mail_to_customer_and_staff, if: :check_if_approved?

  def end_at
    start_at + duration.minutes
  end

  def increase_reminder_time
    if(reminder_time > Time.current)
      reminder_job = Delayed::Job.find_by(id: reminder_job_id)
      if(reminder_job)
        reminder_job.update_attribute(:run_at, reminder_time)
      else
        CustomerMailer.delay(run_at: reminder_time).reminder(self)
      end
    end
  end

  def decrease_reminder_time
    reminder_job = Delayed::Job.find_by(id: reminder_job_id)
    if(reminder_job)
      if(reminder_time > Time.current)
        reminder_job.update_attribute(:run_at, reminder_time)
      else
        reminder_job.delete
      end
    end
  end

  # [rai] please use arel or sql
  def get_availabilities
    if(staff)
      @availabilities = Availability.where("staff_id = '#{ staff.id }'")
      @availabilities = @availabilities.select do |availability|
        availability.service_ids.include?(service.id) && availability.start_date <= start_at.to_date && availability.end_date >= start_at.to_date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight && availability.days.include?(start_at.to_date.wday)
      end
    else
      get_availabilities_for_service
    end
  end

  def get_available_times
    get_availabilities
    @matching_times = {}
    start_at_copy = start_at
    @availabilities.each do |availability|
      populate_matching_times(availability, start_at_copy, :-, :time_less_than_start_at)
      populate_matching_times(availability, start_at_copy, :+, :time_greater_than_start_at)
      return @matching_times if(@matching_times[:time_greater_than_start_at] && @matching_times[:time_less_than_start_at])
    end
    @matching_times
  end

  # [rai] we need to refactor this method. please discuss
  def populate_matching_times(availability, start_at_copy, operator, time)
    while((start_at_copy.to_date == start_at.to_date) && !@matching_times[time]) do
      if(!availability.staff.is_occupied?(start_at_copy, start_at_copy + duration.minutes, start_at_copy.to_date, id) && availability.start_at.seconds_since_midnight <= start_at_copy.seconds_since_midnight && availability.end_at.seconds_since_midnight >= (start_at_copy + duration.minutes).seconds_since_midnight)
        @matching_times[time] = start_at_copy
      end
      start_at_copy =  start_at_copy.send(operator, 15.minutes)
    end
  end

  protected

  # [rai] having trouble following the architecture for reminder job. Please discuss and we will find the optimized solution
  def send_new_appointment_mail_to_customer_and_staff
    CustomerMailer.delay.new_appointment_notifier(self)
    StaffMailer.delay.new_appointment_notifier(self)
    update_column(:reminder_job_id, (CustomerMailer.delay(run_at: reminder_time).reminder(self).id))
  end

  def send_edit_appointment_mail_to_customer_and_staff
    CustomerMailer.delay.edit_appointment_notifier(self)
    StaffMailer.delay.edit_appointment_notifier(self)
    reminder_job = Delayed::Job.find_by(id: reminder_job_id)
    if(reminder_job)
      reminder_job.update_attribute(:run_at, reminder_time)
    else
      CustomerMailer.delay(run_at: reminder_time).reminder(self)
    end
  end

  def reminder_time
    start_at - customer.reminder_time_lapse.minutes
  end

  def check_if_approved?
    state == 'approved'
  end

  def staff_allotable?
    if(staff.is_available?(start_at, end_at,start_at.to_date, service))
      @clashing_appointment = staff.is_occupied?(start_at, end_at,start_at.to_date, id)
      if(@clashing_appointment)
        errors[:staff] << "is occupied from #{ @clashing_appointment.start_at.strftime("%H:%M") } to #{ @clashing_appointment.end_at.strftime("%H:%M") }"
      end
    else
      errors[:base] <<  'No availability for this time duration for this staff.'
    end
  end

  def assign_staff
    get_availabilities_for_service
    if(@availabilities.empty?)
      errors[:base] <<  'No availability for this time duration.'
      return false
    else
      set_staff
    end
  end
  
  def ensure_customer_has_no_prior_appointment_at_same_time
    unless has_no_clashing_appointments?(customer)
      errors[:base] << "You already have an overlapping appointment from #{ @clashing_appointment.start_at.strftime("%H:%M") } to #{ @clashing_appointment.end_at.strftime("%H:%M") }"
    end
  end

  def has_no_clashing_appointments?(user)
    @clashing_appointment = user.appointments.approved.detect do |appointment|
      appointment.id != id && appointment.start_at.to_date == start_at.to_date && ((start_at >= appointment.start_at && start_at < appointment.end_at) || (end_at > appointment.start_at && end_at <= appointment.end_at))
    end
    if(@clashing_appointment)
      false
    else
      true
    end
  end

  def get_availabilities_for_service
    @availabilities = service.availabilities
    @availabilities = @availabilities.select do |availability|
      availability.start_date <= start_at.to_date && availability.end_date >= start_at.to_date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight && availability.days.include?(start_at.to_date.wday)
    end
  end

  def set_staff
    @staffs = @availabilities.map(&:staff)
    self.staff = @staffs.detect do |staff|
      has_no_clashing_appointments?(staff)
    end
    if(!self.staff)
      errors[:base] << 'No staff available for this time duration'
      return false
    end
  end

  def ensure_duration_not_less_than_service_duration
    unless(duration >= service.duration)
      errors[:duration] << "must be greater than or equal to #{ service.duration }"
    end
  end

end
