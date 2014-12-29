class StaffMailer < ActionMailer::Base

  default from: 'test.vinsol.ams@gmail.com'

  def new_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: 'Appointment Created'
  end

  def edit_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: 'Appointment Edited'
  end

  def cancel_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: 'Appointment Cancelled'
  end

  def notify(staff)
    @staff = staff
    @appointments = Appointment.approved.where(staff_id: @staff.id)
    @appointments = @appointments.select do |appointment|
      appointment.start_at.to_date == Date.today
    end
    mail to: @staff.email, subject: 'Daily Appointments'
  end

end