class Service < ActiveRecord::Base

  ALLOWED_DURATIONS = [15, 30, 45, 60]

  #callbacks
  # TODO: Rename to something like +ensure_not_allocated+
  before_destroy :check_for_allocations

  #validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :duration, inclusion: { in: ALLOWED_DURATIONS }
  validates :enabled?, inclusion: { in: [true, false] }

  #associations
  has_many :allocations
  has_many :staffs, through: :allocations

  private

  # TODO: Add proper error message explaining the reason why destroy failed.
  def check_for_allocations
    allocations.empty?
  end
end