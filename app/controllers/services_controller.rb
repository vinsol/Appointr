class ServicesController < ApplicationController

  def search
    @services = Service.where("name like '#{ params[:q] }%'")
    render json: @services
  end

end
