class Availability < ActiveRecord::Base

  #validations
  validates :staff, presence: true
  validates :services, presence: true
  validates :enabled, inclusion: { in: [true, false] }
  validate :ensure_dates_are_valid
  validate :ensure_end_at_greater_than_start_at, if: :ensure_dates_are_valid
  validate :ensure_end_date_greater_than_start_date, if: :ensure_dates_are_valid
  validate :ensure_start_date_not_in_past, on: :create, if: :ensure_dates_are_valid
  #associations
  belongs_to :staff
  has_many :availability_services, dependent: :restrict_with_error
  has_many :services, through: :availability_services

  attr_accessor :title, :start, :end

  protected

  def ensure_dates_are_valid
    begin
      Date.parse(start_date.to_s)
    rescue
      errors[:start_date] << 'is invalid.'
    end

    begin
      Date.parse(end_date.to_s)
    rescue
      errors[:end_date] << 'is invalid.'
    end
  end

  def ensure_end_at_greater_than_start_at
    unless start_at < end_at
      errors[:base] << 'End time should be greater than start time.'
    end
  end

  def ensure_end_date_greater_than_start_date
    unless start_date <= end_date
      errors[:base] << 'End date should be greater than start date.'
    end
  end

  def ensure_start_date_not_in_past
    unless start_date >= Date.today
      errors[:start_date] << 'can not be in past'
    end
  end

end