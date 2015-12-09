Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }, only: :sessions
  get 'mailings/manage' => 'mailings#manage'
  get 'mailings/ajouter/:id' => 'mailings#ajouter', as: "ajouter"
  get 'mailings/accepter_inscription/:id/:uid' => 'mailings#accepter_inscription', as: "accepter_inscription"
  get 'mailings/refuser_inscription/:id/:uid' => 'mailings#refuser_inscription', as: "refuser_inscription"
  get 'mailings/manage_inscriptions/:id' => 'mailings#manage_inscriptions', as: "manage_inscriptions"
  get 'mailings/demande_inscription/:id' => 'mailings#demande_inscription', as: "demande_inscription"
  resources :mailings
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'mailings#index'
  

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
