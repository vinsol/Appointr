class CustomersController < ApplicationController
  layout 'customer'

  before_action :user_has_customer_priveleges?, only: :history
  
  def home
  end

  def history
    @active_appointments = current_customer.appointments.where(state: 'approved').where("start_at > '#{ Time.now }'").order(:start_at).includes(:staff, :service)
    @inactive_appointments = current_customer.appointments.where("state != 'approved' OR start_at <= '#{ Time.now }'").order(:start_at).includes(:staff, :service)
  end
end
