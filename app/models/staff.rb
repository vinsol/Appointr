class Staff < User
  validates :name, uniqueness: { case_sensitive: false }
  validates :designation, presence: true
  validates :services, presence: true
  validates :password, presence: :true, if: :should_validate_password?
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }, if: :encrypted_password_changed?
  
  has_many :allocations, dependent: :restrict_with_error
  has_many :services, through: :allocations
  has_many :availabilities, dependent: :restrict_with_error
  has_many :available_services, through: :availabilities, source: 'Service', foreign_key: 'service_id'
  has_many :appointments, dependent: :restrict_with_error
  has_many :appointed_services, through: :appointments, source: 'Service', foreign_key: 'service_id'
  has_many :appointed_customers, through: :appointments, source: 'Customer', foreign_key: 'customer_id'


  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    super if confirmed?
  end

  def is_available?(start_at, end_at, date, service)
    availabilities = Availability.where("staff_id = '#{ id }'")
    availabilities.any? do |availability|
      availability.service_ids.include?(service.id) && availability.start_date <= date && availability.end_date >= date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight
    end
  end

  def is_occupied?(start_at, end_at, date, new_appointment_id)
    appointments.where(state: 'approved').any? do |appointment|
      if new_appointment_id
        appointment.id != new_appointment_id && appointment.start_at.to_date == date && ((start_at.seconds_since_midnight >= appointment.start_at.seconds_since_midnight && start_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight) || (end_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && end_at.seconds_since_midnight <= appointment.end_at.seconds_since_midnight))
      else
        appointment.start_at.to_date == date && ((start_at.seconds_since_midnight >= appointment.start_at.seconds_since_midnight && start_at.seconds_since_midnight < appointment.end_at.seconds_since_midnight) || (end_at.seconds_since_midnight > appointment.start_at.seconds_since_midnight && end_at.seconds_since_midnight <= appointment.end_at.seconds_since_midnight))
      end
    end
  end

  protected

  def should_validate_password?
    encrypted_password.empty? && !new_record?
  end

end
