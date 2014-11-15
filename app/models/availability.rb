class Availability < ActiveRecord::Base
  validates :staff, presence: true
  validates :services, presence: true

  belongs_to :staff
  has_many :services, through: :availability_services
end