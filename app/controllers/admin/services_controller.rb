class Admin::ServicesController < Admin::BaseController

  before_action :load_service, only: [:show, :edit, :update]

  def index
    if params[:enabled].blank?
      @services = Service.order("LOWER(name)").page(params[:page]).per(15)
    else
      @services = Service.where(enabled: params[:enabled]).order("LOWER(name)").page(params[:page]).per(15)
    end
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
    def load_service
      unless @service = Service.find_by(id: params[:id])
        redirect_to admin_services_path, alert: 'No service found.'
      end
    end

    def service_params
      params.require(:service).permit(:name, :duration, :enabled)
    end
end
