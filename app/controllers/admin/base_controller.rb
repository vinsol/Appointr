class Admin::BaseController < ApplicationController

  # [rai] rename to authorize_admin!
  before_action :user_has_admin_priveleges?
  
  layout 'admin'

  def home
  end

end
