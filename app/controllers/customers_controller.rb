class CustomersController < ApplicationController
  layout 'customer'
  
  def home
  end

  def history
    @active_appointments = current_customer.appointments.where(state: 'approved').where("start_at > '#{ Time.now }'").order(:start_at).includes(:staff, :service)
    @inactive_appointments = current_customer.appointments.where.not(state: 'approved').where.not("start_at > '#{ Time.now }'").order(:start_at).includes(:staff, :service)
  end
end
