class HomeController < ApplicationController
  def welcome
    if current_customer
      redirect_to customers_home_path
    else
      redirect_to new_customer_session_path
    end
  end
end