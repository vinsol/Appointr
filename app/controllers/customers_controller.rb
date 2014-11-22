class CustomersController < ApplicationController

  
  def home
  if current_customer
    render layout: 'customer'
  end
  end
end
