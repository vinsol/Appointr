class User < ActiveRecord::Base
  PASSWORD_VALIDATOR_REGEX = /\A[^\s]*\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  #calbacks
  before_save :downcase_email!

  #validations
  validates :name, presence: true

  def self.types
      %w(Admin Customer Staff)
  end

  # TODO: Should be a bang? `downcase_email!`
  def downcase_email!
     self.email = email.downcase
  end
end
