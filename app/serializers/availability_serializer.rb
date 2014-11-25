class AvailabilitySerializer < ActiveModel::Serializer
  attributes :start, :end, :title
  # belongs_to :staff

  def title
    object.staff.name
  end

  def start
    start_hour = object.start_time.localtime.hour
    start_minute = object.start_time.localtime.min
    object.start_date.to_s + 'T' + start_hour.to_s + ':' + start_minute.to_s + ':00'
  end

  def end
    end_hour = object.end_time.localtime.hour
    end_minute = object.end_time.localtime.min
    object.end_date.to_s + 'T' + end_hour.to_s + ':' + end_minute.to_s + ':00'
  end
end
