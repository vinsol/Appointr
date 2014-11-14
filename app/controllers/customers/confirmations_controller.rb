class Customers::ConfirmationsController < Devise::ConfirmationsController
  # TODO: Do we need to keep it? Also, remove the un-necessary commented lines.

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    super
  end
end