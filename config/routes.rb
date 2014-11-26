Rails.application.routes.draw do
  devise_for :admin, skip: :registrations
  devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' }, skip: :registrations
  devise_for :customers, controllers: { confirmations: 'customers/confirmations', registrations: 'customers/registrations' }

  devise_scope :staff do
    patch "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
  end

  root 'home#welcome'

  get 'customer_home' => 'customers#home'

  get 'staff_home' => 'staffs#home'

  get 'availabilities' => 'availabilities#index'
  get 'appointments' => 'appointments#index'

  resources :appointments


  namespace :admin do
    resources :staffs do
      patch 'update_password' => 'staffs#update_password', on: :member
    end
    resources :services, except: :destroy
    resources :availabilities, except: :destroy
    resources :customers, except: [:new, :create]
    resources :application_images, only: :index
    resources :logos, only: [:new, :create, :destroy]
    resources :back_grounds, only: [:new, :create, :destroy]
    get '/' => 'admin#home'
  end

  resources :staffs, except: [:new, :create, :index], constraints: {id: /[0-9]+/} do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  get 'services/search' => 'services#search'
end
