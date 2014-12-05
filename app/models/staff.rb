class Staff < User
  validates :name, uniqueness: { case_sensitive: false }
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

  # TODO: No need to pass date. Also, `has_availability` would be a better name.
  def has_availability?(start_at, end_at, service)

    # TODO: Refactor this. All time and date comparisons in the app can be refactored.
    availabilities.any? do |availability|
      availability.service_ids.include?(service.id) && availability.start_date <= start_at.to_date && availability.end_date >= start_at.to_date && availability.start_at.seconds_since_midnight <= start_at.seconds_since_midnight && availability.end_at.seconds_since_midnight >= end_at.seconds_since_midnight
    end
  end

  def is_occupied?(start_at, end_at, new_appointment_id)
    appointments.any? do |appointment|
      if new_appointment_id
        appointment.id != new_appointment_id  && ((start_at >= appointment.start_at && start_at < appointment.end_at) || (end_at > appointment.start_at && end_at <= appointment.end_at))
      else
        ((start_at >= appointment.start_at && start_at < appointment.end_at) || (end_at > appointment.start_at && end_at <= appointment.end_at))
      end
    end
  end

  protected

  def should_validate_password?
    encrypted_password.empty? && !new_record?
  end

end
