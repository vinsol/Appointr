class Staffs::AppointmentsController < ApplicationController

  before_action :set_appointment, only: [:destroy, :show, :edit, :update]
  before_action :user_has_staff_priveleges?

  def active_appointments
    @appointments = current_staff.appointments.approved.includes(:customer, :service)
    appointments_json = get_appointments_json
    render(json: appointments_json, root: false)
  end

  def past_appointments
    @appointments = current_staff.appointments.past_and_not_cancelled.includes(:customer, :service)
    appointments_json = get_appointments_json
    render(json: appointments_json, root: false)
  end

  def show
  end

  def edit
  end

  def update
    if appointment_params[:state] == 'attended'
      @appointment.attend
    elsif appointment_params[:state] == 'missed'
      @appointment.miss
    end

    @appointment.remarks = appointment_params[:remarks]

    if @appointment.save(validate: false)
      flash[:notice] = 'Appointment successfully updated.'
      respond_to do |format|
        format.js { render :js => "window.location = '/staff_home'" }
      end
    else
      render :show
    end
  end

  protected

  def set_appointment
    unless @appointment = Appointment.find_by(id: params[:id])
      redirect_to admin_path, alert: 'No appointment found.'
    end
  end

  def appointment_params
    params.require('appointment').permit(:state, :remarks)
  end

  def get_appointments_json
    @appointments.map do |appointment|
      { id: appointment.id,
        state: appointment.state,
        title: "#{ appointment.customer.name }, #{ appointment.service.name }",
        start: appointment.start_at,
        end: appointment.end_at
      }
    end
  end

end