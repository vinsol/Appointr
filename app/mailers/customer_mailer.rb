class CustomerMailer < ActionMailer::Base

  default from: 'test.vinsol.ams@gmail.com'

  def new_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment created.'
  end

  def edit_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment edited.'
  end

  def cancel_appointment_notifier(appointment)
    @appointment = appointment
    @customer = @appointment.customer
    mail to: @customer.email, subject: 'Appointment cancelled.'
  end

end