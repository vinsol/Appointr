class Admin::AdminController < ApplicationController

  before_action :user_has_admin_priveleges?, only: :home
  
  layout 'admin'

  def home
  end

end
