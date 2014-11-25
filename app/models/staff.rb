class Staff < User
  validates :designation, presence: true
  validates :services, presence: true
  validates :password, presence: :true, if: :should_validate_password?
  validates :password, confirmation: true, if: :encrypted_password_changed?
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }, if: :encrypted_password_changed?
  
  has_many :allocations
  has_many :services, through: :allocations
  has_many :availabilities
  has_many :available_services, through: :availabilities, source: 'Service', foreign_key: 'service_id'
  has_many :appointments
  has_many :appointed_services, through: :appointments, source: 'Service', foreign_key: 'service_id'
  has_many :appointed_customers, through: :appointments, source: 'Customer', foreign_key: 'customer_id'


  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    super if confirmed?
  end

  def is_available?(start_at, end_at, date, service)
    puts "in is_available"
    availabilities = Availability.where("staff_id = '#{ id }'")
    availabilities.any? do |availability|
      availability.service_ids.include?(service.id) && availability.start_date <= date && availability.end_date >= date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight
    end
  end

  def is_occupied?(start_at, end_at, date)
    appointments.any? do |appointment|
      appointment.start_at.to_date == date && ((start_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && start_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight) || (end_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && end_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight))
    end
  end

  protected

  def should_validate_password?
    encrypted_password.empty? && !new_record?
  end

end

# availabilities[0].service_ids.include?(service.id) && availabilities[0].start_date <= date && availabilities[0].end_date >= date && availabilities[0].start_at.seconds_since_midnight <= start_at.utc.seconds_since_midnight && availabilities[0].end_at.seconds_since_midnight >= end_at.utc.seconds_since_midnight 

        # appointment.date == Date.today && ((appointment.start_at > (Time.now - 5.minutes) && appointment.start_at < (Time.now + 10.minutes)) || (appointment.end_at > (Time.now - 5.minutes)) && appointment.end_at < (Time.now + 10.minutes))
