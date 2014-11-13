class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  #calbacks
  # TODO: Put in a method and call the method here. Avoid using blocks here.
  before_save { self.email = email.downcase }

  #validations
  validates :name, presence: true

  def self.types
      %w(Admin Customer Staff)
  end
end
