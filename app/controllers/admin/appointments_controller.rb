class Admin::AppointmentsController < Admin::BaseController

  before_action :load_appointment, only: [:cancel, :show]
  before_action :ensure_remark_is_present, only: :cancel

  def index
    if params[:state].blank?
      @appointments = Appointment.all
    else
      @appointments = Appointment.where(state: params[:state])
    end

    if params[:search].present?
      @appointments = @appointments.search_for_admin(params[:search])
    end

    if params[:start_date] && params[:end_date]      
      @appointments = @appointments.where("start_at::date >= '#{ params[:start_date] }'::date AND start_at::date <= '#{ params[:end_date] }'::date")
    elsif params[:start_date]      
      @appointments = @appointments.where("start_at::date = '#{ params[:start_date] }'::date")
    end
    @appointments = @appointments.reorder(start_at: :desc).includes(:customer, :staff, :service).page(params[:page]).per(15)
  end

  def active_appointments
    @appointments = Appointment.confirmed.includes(:customer, :staff, :service)
    render(json: @appointments, each_serializer: AdminAppointmentSerializer, root: false)
  end

  def past_appointments
    @appointments = Appointment.not_cancelled_or_confirmed.past.includes(:customer, :staff, :service)
    render(json: @appointments, each_serializer: AdminAppointmentSerializer, root: false)
  end

  def show
  end

  # [rai] can't we just done @appointment.cancel! and handle exception(FIXED)
  def cancel
    @appointment.cancel
    if @appointment.save(validate: false)
      redirect_to admin_path, notice: 'Appointment cancelled'
    else
      redirect_to admin_path, alert: 'Appointment could not be cancelled'
    end
  end

  private

    def load_appointment
      unless @appointment = Appointment.find_by(id: params[:id])
        redirect_to admin_path, alert: 'No appointment found.'
      end
    end

    # [rai] please use serializers. this is not controller responsibility to prepare json representation for appointments(fixed)

    # [rai] could not we just use if else block?(fixed)
    def ensure_remark_is_present
      @appointment.remarks = params[:remarks]
      if @appointment.remarks.blank?
        redirect_to admin_path, alert: 'Please provide a remark to cancel the appointment.'
      end
    end

end
