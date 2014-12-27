module AvailabilitiesHelper

  def get_staff_options
    staff_options = Staff.all.map do |staff|
      [staff.name, staff.id, { 'data-service_ids' => staff.services.map(&:id) }]
    end
    staff_options
  end

  def get_days_array
    ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  end

  def get_day_options
    day_options = []
    Availability::DAY_MAP.each_with_index do |day, index|
      day_options << [day, index, class: 'btn btn-secondary']
    end
    day_options
    # day_options = [['Sunday', 0, class: 'btn btn-secondary'], ['Monday', 1, class: 'btn btn-secondary'], ['Tuesday', 2, class: 'btn btn-secondary'], ['Wednesday', 3, class: 'btn btn-secondary'], ['Thursday', 4, class: 'btn btn-secondary'], ['Friday', 5, class: 'btn btn-secondary'], ['Saturday', 6, class: 'btn btn-secondary']]
  end

  def get_local_time(utc_time)
    utc_time.in_time_zone.strftime("%H:%M")
  end
end