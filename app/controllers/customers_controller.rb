class CustomersController < ApplicationController
  layout 'customer'

  before_action :user_has_customer_priveleges?
  before_action :set_customer, only: :update
  
  def home
  end

  def update
    old_reminder_time_lapse = @customer.reminder_time_lapse
    @customer.reminder_time_lapse = (reminder_params[:days].to_i * 1440) + (reminder_params['time(4i)'].to_i * 60) + reminder_params['time(5i)'].to_i
    new_reminder_time_lapse = @customer.reminder_time_lapse
    if @customer.save
      @customer.change_appointments_reminder_time(old_reminder_time_lapse, new_reminder_time_lapse)
      redirect_to customer_home_path, notice: 'Reminder settings updated'
    else
      render template: 'customers/base/reminder'
    end
  end

  private

  def reminder_params
    params.require(:customer).permit(:time, :days)
  end

  def set_customer
    unless @customer = Customer.find_by(id: params[:id])
      redirect_to root_path, alert: 'No customer found.'
    end
  end

end
