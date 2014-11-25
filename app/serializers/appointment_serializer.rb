class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end

  def title
    "#{ object.staff.name }, #{ object.service.name }"
  end

  def start
    start_hour = object.start_at.localtime.hour
    start_minute = object.start_at.localtime.min
    object.date.to_s + 'T' + start_hour.to_s + ':' + start_minute.to_s + ':00'
  end

  def end
    end_hour = object.end_at.localtime.hour
    end_minute = object.end_at.localtime.min
    object.date.to_s + 'T' + end_hour.to_s + ':' + end_minute.to_s + ':00'
  end

end
