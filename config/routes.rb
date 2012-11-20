LinkmeRuby::Application.routes.draw do

  resources :payments

  match "/links/all" => "user_links#index", :as => :all_links, :all => true
  match "/links" => "user_links#index"
  match "/link/create" => "user_links#create", :as => :create_link, :all => true
  match "/resend/:link_id" => "user_links#resend", :as => :resend_link, :via => [:get]
  match "/complain/:hash" => "requests#spam_complain", :as => :spam_complain, :via => [:get]
  match "/add_watch" => "requests#create_user_watch", :as => :new_user_watch, :via => [:post]
  resources :user_links
  match "/load_user_sites" => 'requests#user_watches_list', :method => 'post'
  match "/load_user_subscription" => 'requests#user_subscription', :method => 'post'
  match "/user_watches/:id" => 'requests#user_watch_destroy', :method => 'delete', :as => :user_watch

  root :to => 'user_links#new'
  mount Resque::Server, :at => "/background"

  devise_for :users

  match "locked" => "requests#user_locked", :as => :user_locked
  match "unlock" => "requests#send_unlock", :as => :user_unlock, :via => [:post]

  match "/wombat-rates" => "site_rates#index", :via => [:get], :as => :rates

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
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

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
# root :to => 'welcome#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
