class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
    @per_day_availabilities = []

    @availabilities.each do |availability|
      start_hour = availability.start_time.localtime.hour
      start_minute = availability.start_time.localtime.min
      end_hour = availability.end_time.localtime.hour
      end_minute = availability.end_time.localtime.min
      day_span = (availability.end_date - availability.start_date).to_i

      (0..day_span).each do |day_number|
        @per_day_availabilities << { title: availability.staff.name,
                                    start: ((availability.start_date + day_number.days).to_s + 'T' + start_hour.to_s + ':' + start_minute.to_s + ':00'),
                                    end: ((availability.start_date + day_number.days).to_s + 'T' + end_hour.to_s + ':' + end_minute.to_s + ':00')
                                  }
      end

    end
    render(json: @per_day_availabilities, root: false)
  end
end