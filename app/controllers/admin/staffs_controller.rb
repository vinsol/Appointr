class Admin::StaffsController < Admin::BaseController

  #callbacks
  before_action :load_staff, only: [:edit, :show, :update]

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
      redirect_to admin_staff_path(@staff), notice: 'Staff succesfully created.'
    else
      render action: :new
    end
  end

  def resend_confirmation_mail
    staff = Staff.find_by(email: params[:email])
    raw_token, staff.confirmation_token = Devise.token_generator.generate(staff.class, :confirmation_token)
    staff.save
    StaffMailer.resend_confirmation_mail(staff, raw_token).deliver
    redirect_to admin_staffs_path, notice: "A confirmation mail has benn sent to #{ staff.name.titleize } at #{ staff.email }"
  end

  def show
  end

  def edit
    unless(@staff.confirmed_at)
      redirect_to admin_staffs_path, alert: 'This staff has not comfirmed his email yet.'
    end
  end

  def update
    service_ids = service_param[:services].split(',')
    if @staff.update(staff_params.merge({ service_ids: service_ids }))
      redirect_to admin_staff_path(@staff), notice: 'Staff succesfully updated.'
    else
      render action: 'edit'
    end
  end

  private

    def service_param
      params.require(:staff).permit(:services)
    end

    def staff_params
      params.require(:staff).permit(:name, :designation, :email, :enabled)
    end

    def load_staff
      unless @staff = Staff.find_by(id: params[:id])
        redirect_to admin_staffs_path, alert: 'No staff found.'
      end
    end

end
