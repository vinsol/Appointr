module AvailabilitiesHelper
  def get_staff_options
    staff_options = Staff.all.map do |staff|
      [staff.name, staff.id, { 'data-services' => staff.services.to_json }]
    end
    staff_options
  end
end