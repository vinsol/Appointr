class Staffs::AppointmentsController < ApplicationController

  before_action :load_appointment, only: [:destroy, :show, :edit, :update]
  before_action :ensure_remark_is_present, only: :destroy
  before_action :authorize_staff

  def active_appointments
    @appointments = current_staff.appointments.approved.includes(:customer, :service)
    render(json: @appointments, each_serializer: StaffAppointmentSerializer, root: false)
  end

  def past_appointments
    @appointments = current_staff.appointments.not_cancelled_or_approved.past.includes(:customer, :service)
    render(json: @appointments, each_serializer: StaffAppointmentSerializer, root: false)
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

  private

    def load_appointment
      unless @appointment = Appointment.find_by(id: params[:id])
        redirect_to admin_path, alert: 'No appointment found.'
      end
    end

    def appointment_params
      params.require('appointment').permit(:state, :remarks)
    end

end