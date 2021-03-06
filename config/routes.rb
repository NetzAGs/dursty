Dursty::Application.routes.draw do

  # sale dates
  get "sale_date/index"
  get "public/sale_dates"
  get "public/sale_dates_display"
  match "sale_date/:id/assign/:userid" => "sale_date#assign", :as => :sale_date_assign
  match "sale_date/:id/unassign/:userid" => "sale_date#unassign", :as => :sale_date_unassign

  devise_for :users

  # lagerwart
  resources :items
  resources :shop_bundles
  resources  :stock_changes
  get "stock/index"
  match "stock/showBundle/:id/:location" => "stock#showBundleAtLocation"
  match "items/:id/get-priceoptions" => "items#get_priceoptions", :as => :item_get_priceoptions
  match "stock/:id/sold-bundles/:from/:to" => "stock#sold_bundles", :as => :stock_get_sold_bundles


  # admin
  scope "/admin" do
    resources :users
  end

  # kasse
  get "kasse/uebersicht"
  resources :konto_transactions
  resources :kontos

  # shop
  get "shop/index"
  post "shop/buy"
  match "shop/add_bundle_to_card/:bundle/:amount" => 'shop#addBundleToCard', :as => :shop_add_bundle_to_card
  match "shop/remove_bundle_from_card/:bundle" => 'shop#removeBundleFromCard', :as => :shop_remove_bundle_from_card
  match "shop/order_part_item_amount/:order_part/:order_part_item_id/:amount" => 'shop#changeOrderPartItemAmount', :as => :shop_change_order_part_item
  resources :shop_bundle_categories

  # userkonto
  match "userkonto/:id" => 'userkonto#show', :as => :userkonto_show

  # order
  resources :order
  match "order/:id/update/:bundle/:amount" => 'order#update_bundle_amount', :as => :order_update_bundle_amount
  match "order/:id/delete/:bundle" => 'order#delete_bundle', :as => :order_delete_bundle
  match "order/:id/part/:order_part/item/:order_part_item_id/:amount" => 'order#changePartItemAmount', :as => :order_change_part_item

  # home
  get "home/index"

  # public
  get "public/index"

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'public#index'

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
  #root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
