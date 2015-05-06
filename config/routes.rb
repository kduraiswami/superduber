require 'resque/server'
require 'resque/scheduler/server'

Rails.application.routes.draw do
  resources :users do
    resources :events
  end

  get 'logout' => 'users#reset_session'
  get 'oauth2' => 'oauth2#index'
  get 'oauth2/callback' => 'oauth2#callback'
  get '/' => "home#index"
  get '/request_uber' => "home#request_uber"

  # root 'home#index'
  get 'ubertest' => 'events#ubertest'

  post '/users/cancel_ride' => 'users#cancel_ride'
  post '/users/uber_status_update' => 'users#uber_status_update'

  root 'users#index'

  get '/user_events' => "events#index"
  get '*path' => redirect('/')

  mount Resque::Server.new, at: "/resque"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
