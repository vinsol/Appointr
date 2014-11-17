class Service < ActiveRecord::Base

  ALLOWED_DURATIONS = [15, 30, 45, 60]

  #validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :duration, inclusion: { in: ALLOWED_DURATIONS }
  validates :enabled, inclusion: { in: [true, false] }

  #associations
  has_many :allocations, dependent: :restrict_with_error
  has_many :staffs, through: :allocations
  has_many :availabilities
  has_many :available_staff, through: :availabilities, source: 'Staff', foreign_key: 'staff_id'


  private

end