class StaffsController < ApplicationController

  #callbacks
  before_action :set_staff, only: [:edit, :show, :update]
  before_action :user_has_staff_priveleges?, only: [:home, :edit, :update, :show]

  layout 'staff'

  def home
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
    @staff = Staff.find_by(id: params[:id])
    if !@staff
      redirect_to staff_home_path, notice: 'Staff does not exists.'
    end
  end

end
