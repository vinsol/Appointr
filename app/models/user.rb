class User < Db1

  # [rai] why password could not have spaces?(required by app)
  PASSWORD_VALIDATOR_REGEX = /\A[^\s]*\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # are we using trackable module?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  #calbacks
  # [rai] you dont need this. Devise already have configuration for case insensitivity. Check devise.rb(removed)

  #validations
  validates :name, presence: true

  # [rai] are we using it anywhere?([gaurav] no. so i removed it)

  # [rai] check devise(removed)
end
