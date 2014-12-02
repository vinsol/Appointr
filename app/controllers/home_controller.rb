class HomeController < ApplicationController
  def welcome
    if current_customer
      redirect_to customer_home_path
    end
  end
end