class AppointmentsController < ApplicationController

  before_action :ensure_dates_are_valid, only: :index
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def active_appointments
    @appointments = current_customer.appointments.where(state: 'approved')
    render(json: @appointments, root: false)
  end

  def inactive_appointments
    @appointments = current_customer.appointments.where.not(state: 'approved')
    render(json: @appointments, root: false)
  end

  def new
    @appointment = Appointment.new
    @appointment.start_at = ((Time.parse params['start']) - 11.hours)
    @appointment.duration = (((Time.parse params['end']) - (Time.parse params['start']))/60).to_i
    respond_to do |format|
      format.js
    end
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.service_id = service_param[:service]
    @appointment.staff_id = staff_param[:staff]
    @appointment.customer_id = current_customer.id
    if @appointment.save
      flash[:notice] = 'Appointment successfully created.'
      respond_to do |format|
        format.js { render :js => "window.location = '#{customer_home_path}'" }
      end
    else
      render :new
    end

  end

  def edit
    @appointment = Appointment.find_by(id: params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    if @appointment.update(appointment_params)
      flash[:notice] = 'Appointment successfully updated.'
      respond_to do |format|
        format.js { render :js => "window.location = '/customer_home'" }
      end
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @appointment.remarks = 'Cancelled by customer.'
    @appointment.cancel
    if @appointment.save
      redirect_to root_path, notice: 'Appointment cancelled'
    else
      render :edit
    end
  end

  protected

  def appointment_params
    params.require(:appointment).permit(:start_at, :duration)
  end

  def service_param
    params.require(:appointment).permit(:service)
  end

  def staff_param
    params.require(:appointment).permit(:staff)
  end

  def set_appointment
    unless @appointment = Appointment.find_by(id: params[:id])
      redirect_to root_path, notice: 'No appointment found.'
    end
  end

  def ensure_dates_are_valid
    if(params[:start] && params[:end])
      begin
        Date.parse(params[:start])
        Date.parse(params[:end])
      rescue ArgumentError
        render status: 422, json: { message: 'Invalid start or end date.' }
      end
    else
      params[:start] = Date.today
      params[:end] = Date.today + 7.days
    end
  end
end