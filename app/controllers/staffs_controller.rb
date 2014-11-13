class StaffsController < ApplicationController

  #callbacks
  before_action :set_staff, only: [:home, :edit, :show, :update]
  before_action :check_admin_logged_in, only: :index
  before_action :admin_or_staff_logged_in?, only: [:update, :edit]
  before_action :check_staff_logged_in, only: :home

  layout 'admin'


  def home
    render layout: 'application'
  end

  def update_password
    @staff = Staff.find_by(id: params[:staff][:id])
    @staff.confirmation_token = nil
    @staff.confirmed_at = Time.now
    if @staff.update(password_update_params)
      redirect_to staff_home_path
    else
      redirect_to :back,
        notice: 'Please re-enter the password.'
    end
  end

  def show
  end

  def edit
  end

  def update
    service_ids = service_param[:services].split(',')
    @staff.service_ids = service_ids
    if @staff.update(staff_params)
      redirect_to staff_path
    else
      render action: 'edit'
    end
  end

  private

  def password_update_params
    params.require(:staff).permit(:password, :password_confirmation)
  end

  def service_param
    params.require(:staff).permit(:services)
  end

  def staff_params
    params.require(:staff).permit(:name, :designation)
  end

  def set_staff
    # TODO: Handle the case if staff is not found.
    @staff = Staff.find_by(id: params[:id])
  end

  def admin_or_staff_logged_in?
    unless current_admin || current_staff
      redirect_to new_admin_session_path
    end
  end

  # TODO: Rename this method also. Same as check_admin_logged_in
  def check_staff_logged_in
    if !current_staff
      redirect_to new_staff_session_path
    end
  end
end
