class Customers::AppointmentsController < Customers::BaseController

  before_action :set_appointment, only: [:show, :edit, :update, :cancel]

  def active_appointments
    @appointments = current_customer.appointments.approved.includes(:staff, :service)
    render(json: @appointments, root: false)
  end

  def past_appointments
    @appointments = current_customer.appointments.past_and_not_cancelled.includes(:staff, :service)
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

  def cancel
    @appointment.remarks = 'Cancelled by customer.'
    @appointment.cancel
    if @appointment.save
      redirect_to request.referer, notice: 'Appointment cancelled'
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
      redirect_to root_path, alert: 'No appointment found.'
    end
  end
end