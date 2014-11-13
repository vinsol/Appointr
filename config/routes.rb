Rails.application.routes.draw do
    devise_for :admin, skip: :registrations
    devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' }
    devise_for :customers, controllers: { confirmations: 'customers/confirmations' }

    devise_scope :staff do
      patch "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
    end

  # devise_for :users, :skip => [:registrations]
  # devise_for :staffs, :customers, :admins, controllers: { confirmations: 'users/confirmations' }#, :skip => :sessions

  root 'customers#home'

  get 'admin' => 'admin#home'
  get 'staff_home' => 'staffs#home'

  namespace :admin do
    resources :staffs do
      patch 'update_password' => 'staffs#update_password', on: :member
    end
    resources :services
  end

  resources :staffs, except: [:new, :create, :index] do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  get 'services/search' => 'services#search'
end
