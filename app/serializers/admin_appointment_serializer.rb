class AdminAppointmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end, :state

  def title
    "#{ object.customer.name }, #{ object.staff.name }, #{ object.service.name }"
  end

  def start
    object.start_at
  end

  def end
    object.end_at
  end

end
