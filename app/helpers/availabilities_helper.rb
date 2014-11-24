module AvailabilitiesHelper
  def get_staff_options
    staff_options = Staff.all.map do |staff|
      [staff.name, staff.id, { 'data-service_ids' => staff.services.map(&:id) }]
    end
    staff_options
  end

  def get_local_time(utc_time)
    utc_time.in_time_zone.strftime("%H:%M")
  end
end