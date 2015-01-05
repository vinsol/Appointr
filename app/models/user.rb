class User < ActiveRecord::Base

  # [rai] why password could not have spaces?
  PASSWORD_VALIDATOR_REGEX = /\A[^\s]*\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # are we using trackable module?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  #calbacks
  # [rai] you dont need this. Devise already have configuration for case insensitivity. Check devise.rb
  before_save :downcase_email

  #validations
  validates :name, presence: true

  # [rai] are we using it anywhere?
  def self.types
      %w(Admin Customer Staff)
  end

  # [rai] check devise
  def downcase_email
     self.email = email.downcase
  end
end
