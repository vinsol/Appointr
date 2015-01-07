class Staff < User

  # [rai] can't two staff have same name in real world?(it is required in this app as per akhil sir)
  validates :name, uniqueness: { case_sensitive: false }
  validates :designation, presence: true
  validates :services, presence: true

  # [rai] not sure why do we need to override the default behaviour?(discuss)
  validates :password, confirmation: true, presence: :true, on: :update
  validates :password_confirmation, presence: true, on: :update
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }, on: :update
  
  has_many :allocations, dependent: :restrict_with_error
  has_many :services, through: :allocations
  has_many :availabilities, dependent: :restrict_with_error
  has_many :available_services, through: :availabilities, source: 'Service', foreign_key: 'service_id'
  has_many :appointments, dependent: :restrict_with_error
  has_many :appointed_services, through: :appointments, source: 'Service', foreign_key: 'service_id'
  has_many :appointed_customers, through: :appointments, source: 'Customer', foreign_key: 'customer_id'

  def password_required?
    super if confirmed?
  end

  # [rai] bad definition. argument should not need date and time separately. it could just be start_time and end_time(fixed)
  # [rai] why skipping arel or sql here. ruby will take more time then sql(fixed)
  def is_available?(start_at, end_at, service)
    availabilities.for_appointment(start_at, end_at).joins(:availability_services).where('availability_services.service_id = ?', service.id).exists?
    # availabilities = Availability.where("staff_id = '#{ id }'")
    # availabilities.any? do |availability|
    #   availability.service_ids.include?(service.id) && availability.start_date <= date && availability.end_date >= date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight && availability.days.include?(start_at.to_date.wday)
    # end
  end

  # [rai] does not this should be a counterpart method of the is_available? method(discuss)
  # [rai] similarly we should do it in sql(discuss)
  # [rai] a truty method should mostly return truty value, not the object itself(discuss)
  def is_occupied?(start_at, end_at, new_appointment_id)
    clashing_appointment = appointments.approved.detect do |appointment|
      if new_appointment_id
        appointment.id != new_appointment_id && appointment.start_at.to_date == date && ((start_at.seconds_since_midnight >= appointment.start_at.seconds_since_midnight && start_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight) || (end_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && end_at.seconds_since_midnight <= appointment.end_at.seconds_since_midnight))
      else
        appointment.start_at.to_date == date && ((start_at.seconds_since_midnight >= appointment.start_at.seconds_since_midnight && start_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight) || (end_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && end_at.seconds_since_midnight <= appointment.end_at.seconds_since_midnight))
      end
    end
  end

  # [rai] bad name for this method.
  # [rai] this will create problem in future as password is now compulsory for any existing user(removed)

end
