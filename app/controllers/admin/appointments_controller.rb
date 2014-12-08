class Admin::AppointmentsController < ApplicationController

  before_action :set_appointment, only: [:destroy, :show]
  before_action :ensure_remark_is_present, only: :destroy

  def index
    @appointments = Appointment.all.includes(:customer, :staff, :service)
  end

  def json_index
    @appointments = Appointment.all
    appointments_json = @appointments.map do |appointment|
      { id: appointment.id,
        title: "#{ appointment.customer.name }, #{ appointment.staff.name }, #{ appointment.service.name }",
        start: appointment.start_at,
        end: appointment.end_at
      }
    end
    render(json: appointments_json, root: false)
  end

  def show
  end

  def destroy
    @appointment.cancel
    if @appointment.save
      redirect_to root_path, notice: 'Appointment cancelled'
    else
      render :show
    end
  end

  def search
    if params[:search].empty?
      @appointments = Appointment.all
    else
      @appointments = Appointment.search Riddle::Query.escape(params[:search])
    end
  end

  protected

  def set_appointment
    unless @appointment = Appointment.find_by(id: params[:id])
      redirect_to admin_path, notice: 'No appointment found.'
    end
  end

  def ensure_remark_is_present
    unless params[:remarks].empty?
      @appointment.remarks = params[:remarks]
    end
    if @appointment.remarks.nil?
      redirect_to admin_path, notice: 'Please provide a remark to cancel the appointment.'
    end
  end

end