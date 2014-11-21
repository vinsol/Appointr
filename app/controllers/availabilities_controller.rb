class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.select("staff_id, 'event' AS title, start_date AS start, end_date AS end").where("start_date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }' OR end_date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }'")
    @availabilities.each { |availability| availability.title = availability.staff.name }
    render json: @availabilities.to_json
  end
end