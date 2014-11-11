class AdminsController < ApplicationController

  before_action :check_admin_logged_in, only: :home
  
  def home
  end
  
end
