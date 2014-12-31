class AdminMailer < ActionMailer::Base

  default from: 'test.vinsol.ams@gmail.com'

  def day_appointments_notifier
    @staffs = Staff.all.includes(:appointments)
    mail to: Admin.first.email, subject: "Today's Appointments"
  end

end