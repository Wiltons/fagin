Fagin::Application.routes.draw do
  get "fetches/new"
  resources :users
  resources :pushes, only: [:new, :create, :index, :destroy, :show, :undo, :run]
  resources :fetches, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :articles, only: [:index]
  resources :tags, only: [:show, :index]
  root 'static_pages#home'
  match '/signup',	to:'users#new',			              via: 'get'
  match '/push',    to:'pushes#new',                  via: 'get'
  match '/signin',  to:'sessions#new',                via: 'get'
  match '/signout', to:'sessions#destroy',            via: 'delete'
  match '/help',	  to:'static_pages#help',		        via: 'get'
  match '/about',	  to:'static_pages#about',	        via: 'get'
  match '/contact',	to:'static_pages#contact',	      via: 'get'
  match '/pushes/:id/undo', to:'pushes#undo',           via: 'get', as: :pushes_undo
  match '/pushes/:id/run' , to:'pushes#run',          via: 'get', as: :pushes_run
  match '/auth/pocket/callback',  to:'sessions#create',  via: 'get'
  match '/auth/failure', to:'sessions#failure', via: 'get'
  match '/show/populate_articles', to:'users#populate_articles', via: 'post'
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
