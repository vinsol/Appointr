class Appointment < ActiveRecord::Base

  include Timeable

  # Associations
  belongs_to :customer
  belongs_to :staff
  belongs_to :service

  # Validations
  validates :service, :customer, :start_at, :duration, :date, presence: true
  validates :duration, numericality: { greater_than_or_equal_to: @service_duration || 15}, if: :service
  validate :appointment_time_not_in_past, :if :start_at
  validate :staff_allotable?, if: :staff
  before_save :assign_staff, unless: :staff


  # Callbacks
  before_validation :set_service_duration, if: :duration


  def end_at
    start_at + duration.minutes
  end

  protected

  def appointment_time_not_in_past
    if(date == Date.today)
      if(start_at.seconds_since_midnight < Time.now.seconds_since_midnight)
        errors[:time] << 'can not be in past'
      end
    elsif(date < Date.today)
      errors[:date] << 'can not be in past'
      false
    end
  end

  def staff_allotable?
    puts 'staff allotable?'
    if(staff.is_available?(start_at, end_at, date, service))
      puts 'staff is available'
      if(staff.is_occupied?(start_at, end_at, date))
        errors[:staff] << 'not available for this duration.'
      else
        puts 'staff is not occupied'
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

  # def duration_available
  #   if(staff)
  #     staff_present
  #   else
  #     staff_not_present
  #   end
  # end

  # def staff_not_present
    # get_availabilities_for(service)
    # if(@availabilities.empty?)
    #   set_no_availability_error
    # else
    #   set_staff
    # end
  # end

  # def staff_present
  #   get_availabilities_for(staff)
  #   if(@availabilities.empty?)
  #     set_no_availability_error
  #   else
  #     check_staff_appointments
  #   end
  # end

  def get_availabilities_for_service
    @availabilities = service.availabilities
    @availabilities = @availabilities.select do |availability|
      availability.start_date <= date && availability.end_date >= date && availability.start_time.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_time.seconds_since_midnight >= end_at.seconds_since_midnight
    end
  end

  # def get_staffs_for_availabilities
  #   @staffs = @availabilities.map(&:staff)
  #   @staffs.detect! do |staff|
  #     !staff.appointments.any? do |appointment|
  #       appointment.date == date && (appointment.start_at > start_at || appointment.start_at < end_at) && (appointment.end_at > start_at || appointment.end_at < end_at)
  #     end
  #   end
  # end

  # def set_no_availability_error
  #   errors[:base] << 'No availability for this time duration.'
  # end

  # def set_no_staff_available_error
  #   errors[:base] << 'No staff available for this time duration'
  # end

  # def set_staff_not_available_error
  #   errors[:staff] << 'not available for this time duration'
  # end

  def set_staff
    @staffs = @availabilities.map(&:staff)
    self.staff = @staffs.detect do |staff|
      !staff.appointments.any? do |appointment|
        appointment.date == date && (appointment.start_at > start_at || appointment.start_at < end_at) && (appointment.end_at > start_at || appointment.end_at < end_at)
      end
    end
    if(!self.staff)
      errors[:base] << 'No staff available for this time duration'
      return false
    end
  end

  # def check_staff_appointments
  #   if appointment_clash?
  #     set_staff_not_available_error
  #   end
  # end

  # def appointment_clash?
  #   staff.appointments.any? do |appointment|
  #       appointment.date == date && (appointment.start_at > start_at || appointment.start_at < end_at) && (appointment.end_at > start_at || appointment.end_at < end_at)
  #   end
  # end

  def set_service_duration
    @service_duration = service.duration
  end

  # def check_duration
  #   duration
  # end
end


# availability.start_date <=Date.today && availability.end_date >=Date.today && availability.start_time <= (Time.now - 5.minutes) && availability.end_time >= (Time.now + 10.minutes)
#       availability.start_date <= Date.today && availability.end_date >= Date.today && availability.start_time.seconds_since_midnight <= (Time.now.seconds_since_midnight - 300) && availability.end_time.seconds_since_midnight >= (Time.now.seconds_since_midnight + 600)



