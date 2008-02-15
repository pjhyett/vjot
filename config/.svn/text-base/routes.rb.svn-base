ActionController::Routing::Routes.draw do |map|
  map.resources :users, :has_many => [:jots]
  map.resources :sessions
  
  map.home   '',        :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
end
