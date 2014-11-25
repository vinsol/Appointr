class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end

  def title
    "#{ object.staff.name }, #{ object.service.name }"
  end

  def start
    object.start_at
  end

  def end
    object.end_at
  end

end
