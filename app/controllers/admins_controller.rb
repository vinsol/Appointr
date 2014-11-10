class AdminsController < ApplicationController

  before_action :check_admin_logged_in, only: :home
  layout 'admin'

  def home
    @admin = current_admin
  end

end
