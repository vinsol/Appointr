Rails.application.routes.draw do
    devise_for :admins#, controllers: { confirmations: 'admins/confirmations' }
    devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' , registrations: 'staffs/registrations' }
    devise_for :customers, controllers: { confirmations: 'customers/confirmations' }

    devise_scope :staff do
      put "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
    end

  # devise_for :users, :skip => [:registrations]
  # devise_for :staffs, :customers, :admins, controllers: { confirmations: 'users/confirmations' }#, :skip => :sessions

  root 'customers#home'

  get 'admin' => 'admins#home'
  get 'staff_home' => 'staffs#home'

  resources :services do
    get 'search', on: :collection
  end

  resources :staffs do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

end
