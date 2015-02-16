Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: "admins/sessions",
    registrations: "admins/registrations",
    passwords: "admins/passwords",
    invitations: "invitations"
  }

  require 'sidekiq/web'
  authenticate :admin, lambda { |u| u.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :admins, only: [:index]
  resources :emails, only: [:index, :show], as: :deliveries, controller: "deliveries"
  # Allow "." in the id's by using the constraint
  resources :addresses, only: [], constraints: {id: /[^\/]+/} do
    member do
      get :from
      get :to
    end
  end
  resources :test_emails, only: [:new, :create]
  resources :apps do
    resources :emails, only: :index, as: :deliveries, controller: "deliveries"
    member do
      post 'new_password'
      post 'lock_password'
      get 'dkim'
      post 'toggle_dkim'
    end
  end

  resources :black_lists, only: [:index, :destroy]
  resources :teams, only: :index do
    collection do
      post 'invite'
    end
  end

  resources :clients, only: :index

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: 'landing#index'
  post 'request_invitation' => 'landing#request_invitation'

  get 'dash' => 'main#index'
  get 'status_counts' => 'main#status_counts'
  get 'reputation' => 'main#reputation'

  # Open tracking gifs
  # Deprecating the first form of the url
  get 'o/:delivery_id/:hash' => 'tracking#open', as: "tracking_open"
  get 'o2/:delivery_id/:hash' => 'tracking#open2', as: "tracking_open2"

  # Link tracking
  # Deprecating the first form of the url
  get 'l/:delivery_link_id/:hash' => 'tracking#click', as: "tracking_click"
  get 'l2/:delivery_link_id/:hash' => 'tracking#click2', as: "tracking_click2"

  get '/documentation' => 'documentation#index'

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
