class Staffs::RegistrationsController < Devise::RegistrationsController
  # def create
  #   # @staff = Staff.new(params[:staff])
  #   service_names = params[:staff][:services].split(', ')
  #   params[:staff][:services] = service_names.map { |service_name| Service.find_by(name: service_name) }
  #   # @staff.save
  #   super
  # end

end