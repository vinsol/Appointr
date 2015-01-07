class StaffsController < ApplicationController

  #callbacks
  before_action :load_staff, only: [:edit, :show, :update]
  before_action :authorize_staff, only: [:home, :edit, :update, :show]

  layout 'staff'

  def home
  end

  def show
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

    def load_staff
      @staff = Staff.find_by(id: params[:id])
      if !@staff
        redirect_to staff_home_path, alert: 'No staff found.'
      end
    end

end
