class Customer < User

  # Validations
  validates :password, presence: :true, on: :create
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }

  # Associations
  has_many :appointments, dependent: :restrict_with_error
  has_many :appointed_services, through: :appointments, source: 'Service', foreign_key: 'service_id'
  has_many :appointed_staffs, through: :appointments, source: 'Staff', foreign_key: 'staff_id'

end