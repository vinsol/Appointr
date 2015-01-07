class Customers::AppointmentsController < Customers::BaseController

  before_action :ensure_dates_are_valid, only: :index
  before_action :load_appointment, only: [:show, :edit, :update, :cancel]

  def active_appointments
    @appointments = current_customer.appointments.approved.includes(:staff, :service)
    render(json: @appointments, each_serializer: CustomerAppointmentSerializer, root: false)
  end

  def past_appointments
    @appointments = current_customer.appointments.not_cancelled_or_approved.past.includes(:staff, :service)
    render(json: @appointments, each_serializer: CustomerAppointmentSerializer, root: false)
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
      if(@appointment.send(:has_no_clashing_appointments?, @appointment.customer))
        available_times = @appointment.get_available_times
        if(@appointment.duration >= @appointment.service.duration && !available_times.keys.empty?)
          flash.now[:notice] = "You can have an appointment at "
          flash.now[:notice] += available_times.values.map {|value| value.strftime("%I:%M %p")}.join(' or ')
        elsif(@appointment.duration >= @appointment.service.duration)
          flash.now[:notice] = "Sorry but there is no availability for this service on this day. Please try another day."
        end
      end
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
      available_times = @appointment.get_available_times
      if(@appointment.duration >= @appointment.service.duration && !available_times.keys.empty?)
        flash.now[:notice] = "You can have an appointment at "
        flash.now[:notice] += available_times.values.map {|value| value.strftime("%I:%M %p")}.join(' or ')
      elsif(@appointment.duration >= @appointment.service.duration)
        flash.now[:notice] = "Sorry but there is no availability for this service on this day. Please try another day."
      end
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

  private

    def appointment_params
      params.require(:appointment).permit(:start_at, :duration)
    end

    def service_param
      params.require(:appointment).permit(:service)
    end

    def staff_param
      params.require(:appointment).permit(:staff)
    end

    def load_appointment
      unless @appointment = Appointment.find_by(id: params[:id])
        redirect_to root_path, alert: 'No appointment found.'
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