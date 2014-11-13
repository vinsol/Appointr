class Customers::PasswordsController < Devise::PasswordsController
  def create
    # TODO: Can't we use devise's +resource+ method?
    # Also, if @customer here is nil, it will throw exception.
    @customer = Customer.find_by(email: params[:customer][:email])
    if @customer.confirmed_at
      super
    else
      redirect_to :back, notice: 'This email id is not confirmed. Please confirm first.'
    end
  end
end