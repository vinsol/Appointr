class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
    @availability_json = []
    @availabilities.each do |availability|
      @availability_json << availability.get_full_calendar_json
    end
    render json: @availability_json
  end
end