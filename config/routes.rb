Rails.application.routes.draw do
    devise_for :admins, controllers: { confirmations: 'admins/confirmations' }
    devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' }
    devise_for :customers, controllers: { confirmations: 'customers/confirmations' }

  root 'customers#home'

  get 'admin' => 'admins#home'
  get 'staff' => 'staffs#home'

  resources :services
end
