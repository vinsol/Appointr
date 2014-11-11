Rails.application.routes.draw do
    devise_for :admins#, controllers: { confirmations: 'admins/confirmations' }
    devise_for :staffs, controllers: { confirmations: 'staffs/confirmations' , registrations: 'staffs/registrations' }
    devise_for :customers, controllers: { confirmations: 'customers/confirmations' }

    devise_scope :staff do
      put "/staffs/confirm" => "staffs/confirmations#confirm", :as => :staff_confirm
    end

  # devise_for :users, :skip => [:registrations]
  # devise_for :staffs, :customers, :admins, controllers: { confirmations: 'users/confirmations' }#, :skip => :sessions

    # devise_scope :customer do

    # end


  # devise_for :admins, :skip => [:sessions, :registrations]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # You can have the root of your site routed with "root"
  root 'customers#home'
  # devise_scope :admin_user do get 'admin' => 'devise/sessions#new'; end
  get 'admin' => 'admins#home'
  get 'staff_home' => 'staffs#home'

  resources :services do
    get 'search', on: :collection
  end

  resources :staffs do
    patch 'update_password' => 'staffs#update_password', on: :member
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
