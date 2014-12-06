class Admin::CustomersController < Admin::AdminController

  before_action :set_customer, only: [:edit, :show, :update]

  layout 'admin'

  def index
    @customers = Customer.order(:name).includes(:appointments)
  end

  def edit
  end

  def show
  end

  def update
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: 'Successfully updated'
    else
      render action: :edit
    end
  end

  private
  def set_customer
    unless @customer = Customer.find_by(id: params[:id])
      redirect_to admin_cunstomers_path, notice: 'No such customer.'
    end
  end

  def customer_params
    params.require(:customer).permit(:name, :enabled)
  end

end