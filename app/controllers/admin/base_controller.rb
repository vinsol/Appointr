class Admin::BaseController < ApplicationController

  before_action :user_has_admin_priveleges?
  
  layout 'admin'

  def home
  end

end
