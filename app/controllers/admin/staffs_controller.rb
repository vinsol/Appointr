class Admin::StaffsController < Admin::BaseController

  #callbacks
  before_action :set_staff, only: [:edit, :show, :update]

  def index
    @staffs = Staff.order(:name).includes(:services).page(params[:page]).per(15)
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
    unless(@staff.confirmed_at)
      redirect_to admin_staffs_path, notice: 'This staff has not comfirmed his email yet.'
    end
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
