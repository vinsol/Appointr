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

  attr_accessor :title, :start, :end


  def get_full_calendar_json
    self.title = staff.name
    start_hour = start_time.localtime.hour
    start_minute = start_time.localtime.min
    end_hour = end_time.localtime.hour
    end_minute = end_time.localtime.min

    self.start = start_date.to_s + 'T' + start_hour.to_s + ':' + start_minute.to_s + ':00'
    self.end = start_date.to_s + 'T' + end_hour.to_s + ':' + end_minute.to_s + ':00'

    {  
      title: title,
      start: start,
      end: self.end,
      allDay: false
    }

  end

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