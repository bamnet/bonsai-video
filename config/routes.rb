ActionController::Routing::Routes.draw do |map|
  map.resources :conversions, :member => { :resubmit => [:get, :post] }

  map.resources :videos, :has_many => :thumbnails, :member => { :embed => [:get, :post] }

  map.resources :profiles
  
  
  map.root :controller => "videos"

  #Exposes the video download interface 
  map.connect ':controller/:action/:id/:filename.:format'
  map.connect ':controller/:action.:format'
  
  #Regular routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
