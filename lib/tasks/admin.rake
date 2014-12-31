namespace :admin do
  desc "Send mail to admin daily morning to inform him about the appointments of each staff."
  task :day_appointments => :environment do
    AdminMailer.day_appointments_notifier.deliver
  end
end