class Customer < User
  validates :password, presence: :true, on: :create
  validates :password, format: { with: PASSWORD_VALIDATOR_REGEX, message: 'can not include spaces.' }

end