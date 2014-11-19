class ServicesController < ApplicationController

  def search
    @services = Service.where("name ILIKE '#{ params[:q] }%'")
    render json: @services
  end

end
