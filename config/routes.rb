LinkmeRuby::Application.routes.draw do

  root :to => 'user_links#new'
  ActiveAdmin.routes(self)
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount Resque::Server, :at => "/background"

  match "/links/all" => "user_links#index", :as => :all_links, :all => true
  match "/links" => "user_links#index"
  match "/link/create" => "user_links#create", :as => :create_link, :all => true
  match "/resend/:link_id" => "user_links#resend", :as => :resend_link, :via => [:get]
  match "/complain/:hash" => "requests#spam_complain", :as => :spam_complain, :via => [:get]
  match "/add_watch" => "user_watches#create_user_watch", :as => :new_user_watch, :via => [:post]
  resources :user_links

  match "/send-link" => "user_links#create", :as => :create_link, :via => [:post]

  match "/load_user_sites" => 'user_watches#user_watches_list', :method => 'post'
  match "/load_user_subscription" => 'requests#user_subscription', :method => 'post'
  match "/user_watches/:id" => 'user_watches#user_watch_destroy', :method => 'delete', :as => :user_watch

  match "/account_locked" => "requests#user_locked", :as => :user_locked
  match "/account_unlock" => "requests#send_unlock", :as => :user_unlock, :via => [:post]

  match "/wombat-rates" => "site_rates#index", :via => [:get], :as => :rates
  match "/site-rates/:id" => "site_rates#user_rates", :via => [:get], :as => :user_rates
  match "/recount-rates/:id" => "site_rates#recount_rates", :via => [:post], :as => :recount_rates

  match "/payment/" => "payments#new", :as => :payments
  match "/payment/checkout" => "payments#checkout", :via => [:post], :as => :payments_checkout
  match "/payment/confirm" => "payments#confirm", :via => [:get], :as => :payments_confirm
  match "/payment/complete" => "payments#complete", :as => :payments_complete

  match "/user_promo/create" => "payments#create_user_promo", :via => [:post], :as => :create_user_promo

  match "/about_us" => "requests#contacts", :via => [:get], :as => :contacts
  match "/send_message" => "requests#email_to_admin", :via => [:post], :as => :email_to_admin

  match "/mailing" => "requests#mailing_list_manage", :via => [:post], :as => :mailing
  match "/load_mailing" => "requests#load_mailing", :via => [:get]

  match "/terms" => "requests#terms", :via => [:get], :as => :terms
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
