class Admin::StaffsController < ApplicationController

  #callbacks
  before_action :set_staff, only: [:home, :edit, :show, :update]
  before_action :check_admin_logged_in, only: [:index, :new, :create]
  before_action :admin_or_staff_logged_in?, only: [:update, :edit]
  before_action :check_staff_logged_in, only: :home

  layout 'admin'

  def index
    @staffs = Staff.order(:name).includes(:services)
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    service_ids = service_param[:services].split(',')
    @staff.service_ids = service_ids
    if @staff.save
      redirect_to admin_staff_path(@staff)
    else
      render action: :new
    end
  end

  # TODO: Do we need this action here? It should only be for staff. Remove this from here as well as routes.
  # TODO: Also, look for all other actions and check if they are actually needed.
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
    # resource.save
    if @staff.update(staff_params)
      redirect_to admin_staff_path(@staff)
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
    params.require(:staff).permit(:name, :designation, :email)
  end

  def set_staff
    @staff = Staff.find_by(id: params[:id])
  end

  def admin_or_staff_logged_in?
    unless current_admin || current_staff
      redirect_to new_admin_session_path
    end
  end

  def check_staff_logged_in
    if !current_staff
      redirect_to new_staff_session_path
    end
  end
end
