Rails.application.routes.draw do
  devise_for :admin, skip: :registrations
  devise_for :staffs, controllers: { confirmations: 'staffs/confirmations', registrations: 'staffs/registrations' }
  devise_for :customers, controllers: { confirmations: 'customers/confirmations', registrations: 'customers/registrations' }

  devise_scope :staff do
    patch "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
  end

  root 'home#welcome'

  get 'customer_home' => 'customers#home'
  get 'history' => 'customers#history'

  get 'staff_home' => 'staffs#home'

  namespace :customers do
    get 'availabilities' => 'availabilities#index'
    get 'active_appointments' => 'appointments#active_appointments'
    get 'past_appointments' => 'appointments#past_appointments'
    resources :appointments do
      patch 'cancel' => 'appointments#cancel', on: :member
    end
  end


  namespace :staffs do
    resources :appointments
    get 'active_appointments' => 'appointments#active_appointments'
    get 'past_appointments' => 'appointments#past_appointments'
  end

  namespace :admin do
    resources :staffs do
      patch 'update_password' => 'staffs#update_password', on: :member
    end
    resources :appointments do
      post 'search' => 'appointments#search', on: :collection
      patch 'cancel' => 'appointments#cancel', on: :member
    end
    get 'active_appointments' => 'appointments#active_appointments'
    get 'past_appointments' => 'appointments#past_appointments'
    resources :services, except: :destroy
    resources :availabilities, except: :destroy
    resources :customers, except: [:new, :create]
    resources :application_images, only: :index
    resources :logos, only: [:new, :create, :edit, :update, :destroy]
    resources :back_grounds, only: [:new, :create, :edit, :update, :destroy]
    get '/' => 'admin#home'
  end

  resources :staffs, except: [:new, :create, :index], constraints: {id: /[0-9]+/} do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  get 'services/search' => 'services#search'
end
