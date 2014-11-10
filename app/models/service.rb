class Service < ActiveRecord::Base

  ALLOWED_DURATIONS = [15, 30, 45, 60]

  #validations
  validates :name, presence: true
  validates :duration, inclusion: { in: ALLOWED_DURATIONS }
  validates :enabled?, inclusion: { in: [true, false] }

  #associations
  has_many :allocations
  has_many :staffs, through: :allocations
end