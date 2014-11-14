class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.type == 'Admin'
      admin_path
    elsif resource.type == 'Staff'
      staff_home_path
    else
      root_path
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit(:name, :email, :password, :password_confirmation, :current_password, :designation, :services => [])
    end

    devise_parameter_sanitizer.for(:account_update) do |user|
      user.permit(:name, :email, :password, :password_confirmation, :current_password, :designation, :services => [])
    end
  end

  def user_has_admin_priveleges?
    # TODO: Do not redirect to new_admin_session_path. Redirect to home_path
    if !current_admin
      redirect_to root_path
    end
  end


end
