class Staffs::RegistrationsController < Devise::RegistrationsController

  #callbacks
  before_action :check_admin_logged_in#, if: :current_staff
  # skip_before_action :authenticate_scope!, if: -> { current_admin }

  def create
    super
    service_ids = services_params.split(',')
    resource.service_ids = service_ids
    resource.save
  end

  private

    def services_params
      params.require(:staff).require(:services)
    end

    def staff_params
      params.require(:staff).permit(:name, :designation, :email)
    end

end