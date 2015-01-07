class Admin::BaseController < ApplicationController

  # [rai] rename to authorize_admin!(fixed)
  before_action :authorize_admin
  
  layout 'admin'

  def home
  end

end
