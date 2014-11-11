class ServicesController < ApplicationController

  before_action :set_service, only: [:show, :edit, :update]
  before_action :check_admin_logged_in, only: [:index, :show, :new, :edit, :create, :update]

  layout 'admin'

  def index
    @services = Service.order(:name)
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to @service,
        notice: 'Service was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service,
        notice: 'Service was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def search
    @services = Service.where("name like '#{ params[:q] }%'")
    render json: @services
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    unless @service = Service.find_by(id: params[:id])
      flash[:notice] = 'No service found.'
      redirect_to services_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def service_params
    params.require(:service).permit(:name, :duration, :enabled?)
  end
end
