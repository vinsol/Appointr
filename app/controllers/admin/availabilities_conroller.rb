class Admin::AvailabilitiesController < ApplicationController

  #callbacks
  before_action :set_availability, only [:show, :edit]

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    service_ids = service_param[:services].split(',')
    @availability.services_ids = services_ids
    if @staff.save
      redirect_to admin_avalability_path(@staff)
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def index
    @availabilities = Availability.all
  end

  def update
    service_ids = service_param[:services].split(',')
    @availability.service_ids = service_ids
    if @availability.update(availability_params)
      redirect_to admin_availability_path(@availability)
    else
      render action: 'edit'
    en
  end

  private

  def availability_params
    params.require(:availability).permit(:start_time, :end_time, :start_date, :end_date, :enabled)
  end

  def service_param
    params.require(:availability).permit(:services)
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