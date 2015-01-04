class Admin::AvailabilitiesController < Admin::BaseController

  #callbacks
  before_action :set_availability, only: [:show, :edit, :update]

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.service_ids = service_param
    @availability.staff_id = staff_param[:staff]
    @availability.days = days_param
    if @availability.save
      redirect_to admin_availability_path(@availability), notice: 'Availability successfully created.'
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def index
    @availabilities = Availability.joins(:staff).order('users.name').includes(:services).page(params[:page]).per(15)
  end

  def update
    # [rai] you can better do merge { service_ids: service_param, days: days_param }
    @availability.days = days_param
    if @availability.update(availability_params.merge({ service_ids: service_param }))
      redirect_to admin_availability_path(@availability), notice: 'Availability successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

  def availability_params
    params.require(:availability).permit(:start_at, :end_at, :start_date, :end_date, :enabled)
  end

  def service_param
    # [rai] you can use .compact
    params.require(:availability).require(:service_ids).reject { |service_id| service_id.empty? }
  end

  def days_param
    # [rai] you can use .compact
    params.require(:availability).require(:days).reject { |day| day.empty? }
  end

  def staff_param
    params.require(:availability).permit(:staff)
  end

  def set_availability
    unless @availability = Availability.find_by(id: params[:id])
      redirect_to admin_availabilities_path, alert: 'No availability found.'
    end
  end
end