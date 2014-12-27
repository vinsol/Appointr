class CustomerMailer < ActionMailer::Base

  default from: 'test.vinsol.ams@gmail.com'

  def new_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment Created'
  end

  def edit_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment Edited'
  end

  def cancel_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment Cancelled'
  end

  def reminder(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment Reminder'
  end

end