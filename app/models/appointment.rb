class Appointment < ActiveRecord::Base

  # Associations
  belongs_to :customer
  belongs_to :staff
  belongs_to :service

  # Validations
  validates :service, :customer, :start_at, :duration, presence: true
  # TODO: Lets discuss this.
  validate :ensure_duration_not_less_than_service_duration, if: [:duration, :service]
  validate :ensure_customer_has_no_prior_appointment_at_same_time, if: :customer
  validate :appointment_time_not_in_past, if: :start_at
  validate :staff_allotable?, if: :staff
  before_save :assign_staff, unless: :staff

  def end_at
    start_at + duration.minutes
  end

  protected

  def appointment_time_not_in_past
    if(start_at < (DateTime.now - 1.minutes))
      errors[:time] << 'can not be in past'
    end
  end

  # TODO: Rename. Lets discuss this one.
  def staff_allotable?
    if(staff.has_availability?(start_at, end_at, service))
      if(staff.is_occupied?(start_at, end_at, id))
        errors[:staff] << 'is already booked for this duration.'
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
    unless does_not_clash_for?(customer)
      errors[:base] << 'You already have an overlapping appointment for this time duration.'
    end
  end

  def does_not_clash_for?(user)
    !user.appointments.any? do |appointment|
      appointment.id != id && ((start_at >= appointment.start_at && start_at < appointment.end_at) || (end_at > appointment.start_at && end_at <= appointment.end_at))
    end
  end

  def get_availabilities_for_service
    # TODO: Refactor..
    @availabilities = service.availabilities
    @availabilities = @availabilities.select do |availability|
      availability.start_date <= start_at.to_date && availability.end_date >= start_at.to_date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight
    end
  end

  def set_staff
    @staffs = @availabilities.map(&:staff)
    self.staff = @staffs.detect do |staff|
      # TODO: Do we need to check again??
      does_not_clash_for?(staff)
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
