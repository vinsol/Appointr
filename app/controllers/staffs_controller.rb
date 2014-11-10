class StaffsController < ApplicationController
  def home
  end

  def index
    @staffs = Staff.order(:name)
  end

  def update
    @staff = Staff.find_by(id: params[:staff][:id])
    @staff.confirmation_token = nil
    @staff.confirmed_at = Time.now
    if @staff.update(staff_params)
      redirect_to staff_path,
        notice: 'Staff was successfully updated.'
    else
      redirect_to :back,
        notice: 'Please re-enter the password.'
    end
  end

  private
  def staff_params
    params.require(:staff).permit(:password, :password_confirmation)
  end
end
