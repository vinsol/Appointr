class Customers::PasswordsController < Devise::PasswordsController
  def create
    @customer = Customer.find_by(email: params[:customer][:email])
    debugger
    if @customer.confirmed_at
      super
    else
      redirect_to :back, notice: 'This email id is not confirmed. Please confirm first.'
    end
  end
end