class Admin::StaffsController < Admin::AdminController

  #callbacks
  before_action :set_staff, only: [:edit, :show, :update]
  before_action :staff_logged_in?, only: :home

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

  def show
  end

  def edit
  end

  def update
    service_ids = service_param[:services].split(',')
    unless service_ids.empty?
      @staff.service_ids = service_ids
    end
    if @staff.update(staff_params)
      redirect_to admin_staff_path(@staff)
    else
      render action: 'edit'
    end
  end

  private

  def service_param
    params.require(:staff).permit(:services)
  end

  def staff_params
    params.require(:staff).permit(:name, :designation, :email)
  end

  def set_staff
    @staff = Staff.find_by(id: params[:id])
  end

end
