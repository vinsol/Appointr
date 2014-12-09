class CustomersController < ApplicationController
  layout 'customer'

  before_action :user_has_customer_priveleges?
  
  def home
  end
end
