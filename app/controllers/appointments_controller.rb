class AppointmentsController < ApplicationController

  before_action :ensure_dates_are_valid, only: :index
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index
    @appointments = current_customer.appointments

    # @appointments = current_customer.appointments.where("date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }'")
    render(json: @appointments, root: false)
  end

  def edit
    @appointment = Appointment.find_by(id: params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to root_path, notice: 'Appointment successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @appointment.destroy
      redirect_to root_path, notice: 'Appointment cancelled'
    else
      render :edit
    end
  end

  protected

  def appointment_params
    params.require(:appointment).permit(:staff, :service, :start_at, :duration, :date)
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