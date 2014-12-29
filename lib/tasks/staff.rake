namespace :staff do
  desc "Send mail to staff daily to inform him about the appointments."
  task :daily_appointment_notify => :environment do
    Staff.all.each do |staff|
      StaffMailer.notify(staff).deliver
    end
  end
end