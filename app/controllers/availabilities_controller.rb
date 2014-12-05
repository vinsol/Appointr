class AvailabilitiesController < ApplicationController

  before_action :set_availabilities, only: :index

  def index
    if(params[:staff_id] == '')
      @availabilities = Service.find_by(id: params[:service_id]).availabilities
    else
      @availabilities = Service.find_by(id: params[:service_id]).availabilities.where(staff_id: params[:staff_id])
    end
    @per_day_availabilities = []
    @availabilities.each do |availability|
      start_at_seconds = availability.start_at.seconds_since_midnight
      end_at_seconds = availability.end_at.seconds_since_midnight
      day_span = (availability.end_date - availability.start_date).to_i

      (0..day_span).each do |day_number|
        unless ((availability.start_date + day_number.days) < Date.today)
          @per_day_availabilities << { title: availability.staff.name,
                                      start: (availability.start_date + day_number.days + start_at_seconds.seconds),
                                      end: (availability.start_date + day_number.days + end_at_seconds.seconds),
                                      rendering: 'background'
                                    }
        end
      end

    end
    render(json: @per_day_availabilities, root: false)
  end

  protected

  def set_availabilities
    if(params[:staff_id] == '')
      @availabilities = Service.find_by(id: params[:service_id]).availabilities
    else
      @availabilities = Service.find_by(id: params[:service_id]).availabilities.where(staff_id: params[:staff_id])
    end
  end
end