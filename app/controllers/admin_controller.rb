class AdminController < ApplicationController

  before_action :check_admin_logged_in, only: :home
  
  layout 'application'

  def home
  end

end
