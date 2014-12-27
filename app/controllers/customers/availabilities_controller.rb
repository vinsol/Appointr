class Customers::AvailabilitiesController < Customers::BaseController

  def index

    if(params[:staff_id] != '' && params[:service_id] != '')
      @availabilities = Service.find_by(id: params[:service_id]).availabilities.where(staff_id: params[:staff_id])
    elsif(params[:service_id] != '')
      @availabilities = Service.find_by(id: params[:service_id]).availabilities
    else
      @availabilities = []
    end

    @per_day_availabilities = []
    @availabilities.each do |availability|
      daily_start_at = availability.start_at.localtime.to_s.split(' ')[1]
      daily_end_at = availability.end_at.localtime.to_s.split(' ')[1]
      day_span = (availability.end_date - availability.start_date).to_i

      (0..day_span).each do |day_number|
        availability_date = availability.start_date + day_number.days
        if((availability_date >= Date.today) && (availability.days.include?(availability_date.wday)))
          @per_day_availabilities << { title: availability.staff.name,
                                      start: ((availability_date).to_s + 'T' + daily_start_at),
                                      end: ((availability_date).to_s + 'T' + daily_end_at),
                                      rendering: 'background'
                                    }
        end
      end
    end
    render(json: @per_day_availabilities, root: false)
  end
end