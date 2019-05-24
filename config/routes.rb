Rails.application.routes.draw do
  resources :errors
  resources :logincms, defaults: { format: :json }
  mount Ckeditor::Engine => '/ckeditor'
  get 'callbacks/facebook'
  get "/404", :to => "errors#not_found_error", :via => :all
  get "/500", :to => "errors#internal_server_error", :via => :all
  # get '/404', to: 'application#page_not_found'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :user_blocks, defaults: {format: :json}, only: [:index, :create, :destroy]
  resources :hails, defaults: { format: :json }, only: [:index, :create, :update, :destroy]
  resources :messages, defaults: { format: :json }, only: [:index, :create] do
    collection do
      delete :destroy_all
    end
  end
  resources :pages, param: :slug, defaults: { format: :json }
  resources :interests, defaults: { format: :json }
  resources :banner_managements, defaults: { format: :json }
  resources :user_interest_shares, defaults: { format: :json }
  resources :user_interests, defaults: { format: :json }
  resources :answers, defaults: { format: :json }
  resources :questions, defaults: { format: :json }
  resources :interest_comments, defaults: { format: :json }
  resources :categories, defaults: { format: :json }
  resources :users, defaults: { format: :json }, only: [:index, :show, :create, :update, :destroy]
  resources :user_settings, defaults: { format: :json }, only: [:index, :create]

  resources :notifications

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # get 'content' => 'logincms#index'

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
