ActionController::Routing::Routes.draw do |map|
  map.resources :programs
  map.connect 'adv/:id', :controller => 'advanced'
  map.root :controller => "welcome"

 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
