class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
    # @availabilities = Availability.select("staff_id,start_time , end_time, 'event' AS title, start_time AS start, end_time AS end").where("start_date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }' OR end_date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }'")
    @availability_json = []
    @availabilities.each do |availability|
      @availability_json << availability.get_full_calendar_json
    end
    render json: @availability_json
  end
end