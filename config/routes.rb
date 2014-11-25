Rails.application.routes.draw do
  devise_for :admin, skip: :registrations
  devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' }, skip: :registrations
  devise_for :customers, controllers: { confirmations: 'customers/confirmations' }

  devise_scope :staff do
    patch "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
  end

  root 'customers#home'

  get 'staff_home' => 'staffs#home'

  get 'availabilities' => 'availabilities#index'
  get 'appointments' => 'appointments#index'

  resources :appointments


  namespace :admin do
    resources :staffs do
      patch 'update_password' => 'staffs#update_password', on: :member
    end
    resources :services
    resources :availabilities
    get '/' => 'admin#home'
  end

  resources :staffs, except: [:new, :create, :index], constraints: {id: /[0-9]+/} do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  get 'services/search' => 'services#search'
end
