class CustomerMailer < ActionMailer::Base

  layout 'mailer'
  default from: 'test.vinsol.ams@gmail.com',
          headers: { secret: 'ams-secret-key' }
  def new_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: "Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.staff.name.humanize } Created"
  end

  def edit_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: "Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.staff.name.humanize } Edited"
  end

  def cancel_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment for #{ @appointment.service.name.humanize } with #{ @appointment.staff.name.humanize } Cancelled'
  end

  def reminder(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: "Appointment Reminder for #{ @appointment.service.name.humanize } with #{ @appointment.staff.name.humanize }"
  end

end