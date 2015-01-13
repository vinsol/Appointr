class CustomersController < ApplicationController
  layout 'customer'

  before_action :authorize_customer
  before_action :load_customer, only: :update
  
  def home
  end

  def update
    old_reminder_time_lapse = @customer.reminder_time_lapse
      @customer.reminder_time_lapse = reminder_params[:number].to_i * reminder_params[:time].to_i
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
      params.require(:customer).permit(:time, :number)
    end

    def load_customer
      unless @customer = Customer.find_by(id: params[:id])
        redirect_to root_path, alert: 'No customer found.'
      end
    end

end
