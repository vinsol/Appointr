module AppointmentsHelper
  def get_service_options
    service_options = Service.all.map do |service|
      [service.name, service.id, { 'data-staff_ids' => service.staffs.map(&:id) }]
    end
    service_options
  end
end