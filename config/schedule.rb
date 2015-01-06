# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/cron.log"
# set :environment, 'development'
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


every :day, :at => '05:00am' do
  rake "staff:daily_appointment_notify"
  rake "admin:day_appointments"
end

every :day, :at => '10:00pm' do
  rake "admin:day_appointments"
end

# every :day, :at => '01:14pm' do
# end