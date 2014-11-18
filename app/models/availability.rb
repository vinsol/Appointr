class Availability < ActiveRecord::Base

  #validations
  validates :staff, presence: true
  validates :services, presence: true
  # validates :enabled, inclusion: { in: [true, false] }

  #associations
  belongs_to :staff
  has_many :availability_services, class_name: 'AvailabilityServices', dependent: :destroy
  has_many :services, through: :availability_services
end