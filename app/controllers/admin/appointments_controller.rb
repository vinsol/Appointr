class Admin::AppointmentsController < Admin::BaseController

  before_action :set_appointment, only: [:cancel, :show]
  before_action :ensure_remark_is_present, only: :cancel

  def index
    @appointments = Appointment.all.order(start_at: :desc).includes(:customer, :staff, :service).page(params[:page]).per(15)
  end

  def active_appointments
    @appointments = Appointment.approved.includes(:customer, :staff, :service)
    appointments_json = get_appointments_json
    render(json: appointments_json, root: false)
  end

  def past_appointments
    @appointments = Appointment.past_and_not_cancelled.includes(:customer, :staff, :service)
    appointments_json = get_appointments_json
    render(json: appointments_json, root: false)
  end

  def show
  end

  # [rai] can't we just done @appointment.cancel! and handle exception
  def cancel
    @appointment.cancel
    if @appointment.save
      redirect_to admin_path, notice: 'Appointment cancelled'
    else
      render :show
    end
  end

  # [rai] not sure but can we chain on .all? i remember that .all returns array and not arel
  # [rai] moreover we dont need to repeat the code the chaining could go at last line with variable @appointments
  def search
    if params[:search].empty?
      @appointments = Appointment.all.order(start_at: :desc).includes(:staff, :service, :customer).page(params[:page]).per(15)
    else
      @appointments = Appointment.search_for_admin(params[:search]).order(start_at: :desc).includes(:staff, :service, :customer).page(params[:page]).per(15)
    end
  end

  protected

  def set_appointment
    unless @appointment = Appointment.find_by(id: params[:id])
      redirect_to admin_path, alert: 'No appointment found.'
    end
  end

  # [rai] please use serializers. this is not controller responsibility to prepare json representation for appointments
  def get_appointments_json
    @appointments.map do |appointment|
      { id: appointment.id,
        title: "#{ appointment.customer.name }, #{ appointment.staff.name }, #{ appointment.service.name }",
        start: appointment.start_at,
        end: appointment.end_at
      }
    end
  end

  # [rai] could not we just use if else block?
  def ensure_remark_is_present
    unless params[:remarks].empty?
      @appointment.remarks = params[:remarks]
    end
    if @appointment.remarks.nil?
      redirect_to admin_path, alert: 'Please provide a remark to cancel the appointment.'
    end
  end

end
