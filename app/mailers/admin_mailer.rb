class AdminMailer < ActionMailer::Base

  layout 'mailer'
  default from: 'test.vinsol.ams@gmail.com',
          headers: { secret: 'ams-secret-key' }

  def day_appointments_notifier
    @staffs = Staff.all.includes(:appointments)
    mail to: Admin.first.email, subject: "Appointments for #{ Date.current }"
  end

end