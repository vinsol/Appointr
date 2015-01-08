class Customers::BaseController < ApplicationController

  before_action :user_has_customer_priveleges?
  
  layout 'customer'

  def appointment_history
    @active_appointments = current_customer.appointments.confirmed.future.order(:start_at).limit(5).includes(:staff, :service)
    @inactive_appointments = current_customer.appointments.past_or_cancelled.order(start_at: :desc).limit(5).includes(:staff, :service)
  end

  def active_appointments_index
    @active_appointments = current_customer.appointments.confirmed.future.order(:start_at).includes(:staff, :service).page(params[:page]).per(12)
  end

  def inactive_appointments_index
    @inactive_appointments = current_customer.appointments.past_or_cancelled.order(start_at: :desc).includes(:staff, :service).page(params[:page]).per(12)
  end

  def reminder
    @customer = current_customer
  end

end
