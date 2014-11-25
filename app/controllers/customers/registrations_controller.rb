class Customers::RegistrationsController < Devise::RegistrationsController
  layout 'customer', only: :edit
end
