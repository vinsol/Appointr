class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  #calbacks
  before_save { self.email = email.downcase }

  #validations
  validates :name, presence: true
  validates :password, format: { with: /\A[^\s]+\z/i, message: 'can not include spaces.' }

  def self.types
      %w(Admin Customer Staff)
  end
end
