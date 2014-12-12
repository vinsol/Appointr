class Customers::BaseController < ApplicationController

  before_action :user_has_customer_priveleges?
  
  layout 'customer'

  def appointment_history
    @active_appointments = current_customer.appointments.approved.future.order(start_at: :desc).includes(:staff, :service)
    @inactive_appointments = current_customer.appointments.past_or_cancelled.order(start_at: :desc).includes(:staff, :service)
  end

end