Rails.application.routes.draw do

    devise_for :admins
    devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' }
    devise_for :customers, controllers: { confirmations: 'customers/confirmations', passwords: 'customers/passwords' }

  root 'customers#home'

  get 'admin' => 'admins#home'
  get 'staff' => 'staffs#home'

  resources :services

end
