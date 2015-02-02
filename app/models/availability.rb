class Availability < ActiveRecord::Base
  
  # [rai] why do we need it here? you already have get_days_array in AvailabilitiesHelper(moved to avaialbilities_helper)
  #validations
  validates :staff, :days, presence: true
  validates :services, presence: true
  validates :enabled, exclusion: { in: [nil] }
  
  # [rai] again? just presence validation should do it(fixed)
  validate :ensure_dates_are_valid
  # [rai] please discuss this with me. if ensure dates are valid then why do i need to check again ensure_end_date_greater_than_start_date.([gaurav] ensure_dates_are_valid just checks if date format is valid.)
  # [rai] either you correct the names. also order should be different.(to discuss)
  validate :ensure_end_at_greater_than_start_at, if: :ensure_dates_are_valid
  validate :ensure_end_date_greater_than_start_date, if: :ensure_dates_are_valid
  validates :start_date, future: true,on: :create, if: :ensure_dates_are_valid

  #associations
  belongs_to :staff
  has_many :availability_services, dependent: :restrict_with_error
  has_many :services, through: :availability_services

  #scopes
  scope :for_appointment, -> (start_at, end_at) { where("start_date <= '#{ start_at.to_date }' AND end_date >= '#{ start_at.to_date }' AND start_at::time <= '#{ start_at.strftime('%Y-%m-%d %H:%M:%S')}'::time AND end_at::time >= '#{ end_at.strftime('%Y-%m-%d %H:%M:%S')}'::time AND #{ start_at.to_date.wday } = ANY (days)") }

  attr_accessor :title, :start, :end

  # [rai] why protected and not private. do we have any subclass of Availability(fixed)
  private

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
        # [rai] you should add error to :end_time([gaurav]bcoz we can change either start_time or end_time)
        errors[:base] << 'End time should be greater than start time.'
      end
    end

    def ensure_end_date_greater_than_start_date
      unless start_date <= end_date
        # [rai] you should add error to :end_date([gaurav]bcoz we can change either start_date or end_date)
        errors[:base] << 'End date should be greater than start date.'
      end
    end

end