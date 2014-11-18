class Admin::AvailabilitiesController < ApplicationController

  #callbacks
  before_action :set_availability, only: [:show, :edit, :update]

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.service_ids = service_param
    @availability.staff_id = staff_param[:staff]
    # @availability.start_time = TimeOfDay.set(time_params['start_time(4i)'].to_i, time_params['start_time(5i)'].to_i)
    # @availability.end_time = TimeOfDay.set(time_params['end_time(4i)'].to_i, time_params['end_time(5i)'].to_i)
    set_time
    if @availability.save
      redirect_to admin_availability_path(@availability)
    else
      render action: 'new'
    end
  end

  def show
  end

  def edit
  end

  def index
    @availabilities = Availability.joins(:staff).order('users.name')
  end

  def update
    # service_ids = service_param[:services].split(',')
    @availability.service_ids = service_param
    # if(staff_param[:staff])
    #   @availability.staff_id = staff_param[:staff]
    # end
    # @availability.start_time = TimeOfDay.set(time_params['start_time(4i)'].to_i, time_params['start_time(5i)'].to_i)
    # @availability.end_time = TimeOfDay.set(time_params['end_time(4i)'].to_i, time_params['end_time(5i)'].to_i)
    set_time
    if @availability.update(availability_params)
      redirect_to admin_availability_path(@availability)
    else
      render action: 'edit'
    end
  end

  private

  def set_time
    @availability.start_time = TimeOfDay.set(time_params['start_time(4i)'].to_i, time_params['start_time(5i)'].to_i)
    @availability.end_time = TimeOfDay.set(time_params['end_time(4i)'].to_i, time_params['end_time(5i)'].to_i)
  end

  def availability_params
    params.require(:availability).permit(:start_date, :end_date, :enabled)
  end

  def time_params
    params.require(:availability).permit(:start_time, :end_time)
  end

  def service_param
    params.require(:availability).require(:service_ids).reject { |service_id| service_id.empty? }
  end

  def staff_param
    params.require(:availability).permit(:staff)
  end

  def set_availability
    unless @availability = Availability.find_by(id: params[:id])
      redirect_to admin_availabilities_path, notice: 'No availability found.'
    end
  end
end