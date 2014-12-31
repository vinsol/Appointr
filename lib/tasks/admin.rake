namespace :admin do
  desc "Send mail to admin daily morning to inform him about the appointments of each staff."
  task :daily_appointments => :environment do
    AdminMailer.daily_appointments_notifier.deliver
  end
end