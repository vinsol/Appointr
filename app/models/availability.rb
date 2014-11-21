class Availability < ActiveRecord::Base

  include Timeable

  #validations
  validates :staff, presence: true
  validates :services, presence: true
  validates :enabled, inclusion: { in: [true, false] }
  validate :check_end_time_greater_than_start_time
  validate :check_end_date_greater_than_start_date
  validate :check_for_past_dates

  #associations
  belongs_to :staff
  has_many :availability_services, class_name: 'AvailabilityService', dependent: :destroy
  has_many :services, through: :availability_services


  protected

  def check_end_date_greater_than_start_date
    unless start_date <= end_date
      errors[:base] << 'End date should be greater than start date.'
    end
  end

  def check_for_past_dates
    unless start_date >= Date.today
      errors[:start_date] << 'can not be in past'
    end
  end

end