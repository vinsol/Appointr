class StaffsController < ApplicationController

  #callbacks
  before_action :set_staff, only: [:edit, :show, :update]
  before_action :check_admin_logged_in, only: [:update, :edit]


  def home
  end

  def index
    @staffs = Staff.order(:name)
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
    if @staff.update(staff_params)
      redirect_to staff_home_path
    else
      render action: 'edit'
    end
  end

  private

  def password_update_params
    params.require(:staff).permit(:password, :password_confirmation)
  end

  def staff_params
    params.require(:staff).permit(:name, :designation, :services)
  end

  def set_staff
    @staff = Staff.find_by(id: params[:id])
  end
end
