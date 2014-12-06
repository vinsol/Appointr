# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( availability.js availability_filter.js fullcalendar.css fullcalendar.js moment.min.js jquery.min.js customer_appointment.js appointment_filter.js admin_appointment.js staff_appointment.js bootstrap.min.js jquery.js jquery-ui.js jquery-ui.css)
