class Customers::ConfirmationsController < Devise::ConfirmationsController
  layout 'application'
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    super
  end
end