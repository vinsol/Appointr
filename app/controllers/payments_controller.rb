class PaymentsController < ActionController::Base
  def pay
  end

  def get_payment
    transaction = WebpayInterswitch::TransactionQuery.new(params, 200)
    debugger
    if transaction.success?
      redirect_to successful_path, notice: 'Payment Successful'
    else
      redirect_to unsuccessful_path, alert: 'Payment Not Successful'
    end
  end

  def successful
  end

  def unsuccessful
  end
end