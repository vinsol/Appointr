class Admin::ServicesController < Admin::BaseController

  before_action :set_service, only: [:show, :edit, :update]

  def index
    @services = Service.order("LOWER(name)")
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
      redirect_to admin_service_path(@service),
        notice: 'Service was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @service.update(service_params)
      redirect_to admin_service_path(@service),
        notice: 'Service was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    unless @service = Service.find_by(id: params[:id])
      flash[:notice] = 'No service found.'
      redirect_to admin_services_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white
  # list through.
  def service_params
    params.require(:service).permit(:name, :duration, :enabled)
  end
end
