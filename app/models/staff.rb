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

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def password_required?
    super if confirmed?
  end

  def should_validate_password?
    encrypted_password.empty? && !new_record?
  end
end