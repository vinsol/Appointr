class StaffMailer < ActionMailer::Base

  layout 'mailer'
  default from: 'test.vinsol.ams@gmail.com',
          headers: { secret: 'ams-secret-key' }

  def new_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: "Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.customer.name.humanize } Created"
  end

  def edit_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: "Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.customer.name.humanize } Edited"
  end

  def cancel_appointment_notifier(appointment)
    @appointment = appointment
    @staff = @appointment.staff
    mail to: @staff.email, subject: "Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.customer.name.humanize } Cancelled"
  end

  def notify(staff)
    @staff = staff
    @appointments = Appointment.confirmed.where(staff_id: @staff.id)
    @appointments = @appointments.select do |appointment|
      appointment.start_at.to_date == Date.today
    end
    mail to: @staff.email, subject: "Your Appointments for #{ Date.current }"
  end

end