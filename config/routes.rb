ActionController::Routing::Routes.draw do |map|

  map.resources :projects, :as => "#{$projects_name_replacement}", :requirements => { :id => /.+/ } do |projects| projects.resources :pages, :as => "#{$pages_name_replacement}", :requirements => { :id => /.+/ } end 

  map.connect 'projects/new', :controller => 'projects', :action => 'new', :as => "#{$projects_name_replacement}/new"
  map.connect 'pages/new', :controller => 'pages', :action => 'new', :as => "#{$pages_name_replacement}/new"

  map.connect 'projects/:name', :controller => 'projects', :action => 'show', :conditions => { :method => :get }, :as => "#{$projects_name_replacement}/:name"
  map.connect 'pages/:name', :controller => 'pages', :action => 'show', :conditions => { :method => :get }, :as => "#{$pages_name_replacement}/:name"
  
  map.resources :project_images

  map.connect '/events/show_hide_page_fields', :controller => 'events', :action => 'show_hide_page_fields'

  map.connect '/events/:path', :controller => 'events', :action => 'auto_complete_for_event_connection_dialog', :requirements => { :path => /auto_complete_for_connection_dialogs_connection_dialog_\d*_\d*/ }
  map.connect '/events/:path', :controller => 'events', :action => 'auto_complete_for_event_affiliation', :requirements => { :path => /auto_complete_for_affiliations_affiliation_\d*_\d*/ }
  map.connect '/events/:path', :controller => 'events', :action => 'auto_complete_for_event_organization', :requirements => { :path => /auto_complete_for_organizations_organization_\d*_\d*/ }
  map.connect '/events/:path', :controller => 'events', :action => 'auto_complete_for_event_tag', :requirements => { :path => /auto_complete_for_tags_tag_\d*_\d*/ }

  map.auto_complete ':controller/:action',
     :requirements => { :action => /auto_complete_for_\S+/ },
     :conditions => { :method => :get }

  map.view '/users/manage_events', :controller => 'users', :action => 'manage_events'
  map.view '/users/manage_profile', :controller => 'users', :action => 'manage_profile'

  map.view '/events/list_events', :controller => 'events', :action => 'list_events' 
  map.view "/users/manage_#{$projects_name_replacement}", :controller => 'projects', :action => 'list_projects'
  map.view "/users/manage_#{$pages_name_replacement}", :controller => 'pages', :action => 'list_pages'
  map.view '/funders/list_funders', :controller => 'funders', :action => 'list_funders' 

  map.resources :events

  map.resources :funders

  map.resources :projects, :requirements => { :id => /.+/ }, :as => "#{$projects_name_replacement}"

  map.resources :pages, :requirements => { :id => /.+/ }, :as => "#{$pages_name_replacement}"

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate',:activation_code => nil

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'new'

  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'
  map.reset_password '/change_password', :controller => 'users', :action => 'change_password'

  map.resources :users
  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'home'
  map.home '', :controller => 'controller', :action => 'action'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  #static routes
  map.connect ':action', :controller => "static"  
end
