Rails.application.routes.draw do
  devise_for :admin, skip: :registrations
  devise_for :staffs, controllers: { confirmations: 'staffs/confirmations', registrations: 'staffs/registrations' }
  devise_for :customers, controllers: { confirmations: 'customers/confirmations', registrations: 'customers/registrations' }

  devise_scope :staff do
    patch "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
  end

  root 'home#welcome'

  get 'customers/home' => 'customers#home'

  get 'staffs/home' => 'staffs#home'

  resources :customers, only: :update
  namespace :customers do
    get 'availabilities' => 'availabilities#index'
    get 'active_appointments' => 'appointments#active_appointments'
    get 'appointment_history' => 'base#appointment_history'
    get 'active_appointments_index' => 'base#active_appointments_index'
    get 'inactive_appointments_index' => 'base#inactive_appointments_index'
    get 'past_appointments' => 'appointments#past_appointments'
    get 'reminder_settings' => 'base#reminder'
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
    resources :staffs
    patch 'staff_resend_confirmation_mail' => 'staffs#resend_confirmation_mail'
    resources :appointments do
      get 'search' => 'appointments#index', on: :collection
      patch 'cancel' => 'appointments#cancel', on: :member
    end
    get 'active_appointments' => 'appointments#active_appointments'
    get 'past_appointments' => 'appointments#past_appointments'
    resources :services, except: :destroy
    resources :availabilities, except: :destroy
    resources :customers, except: [:new, :create]
    resources :application_images, only: :index
    resources :logos, only: [:new, :create, :edit, :update, :destroy]
    resources :backgrounds, only: [:new, :create, :edit, :update, :destroy]
    get '/' => 'base#home'
  end

  resources :staffs, except: [:new, :create, :index], constraints: {id: /[0-9]+/} do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  get 'services/search' => 'services#search'
  match '*other', :to => redirect('/404.html'), via: [:get]
end
