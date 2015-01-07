class Admin::CustomersController < Admin::BaseController

  # [rai] its should be load_customer or find_customer(fixed)
  before_action :load_customer, only: [:edit, :show, :update]

  def index
    @customers = Customer.order(:name).includes(:appointments).page(params[:page]).per(15)
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
    def load_customer
      unless @customer = Customer.find_by(id: params[:id])
        redirect_to admin_cunstomers_path, alert: 'No customer found.'
      end
    end

    def customer_params
      params.require(:customer).permit(:name, :enabled)
    end

end