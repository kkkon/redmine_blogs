ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:project_id/blogs/:action', :controller => 'blogs'
  map.connect 'projects/:project_id/blogs.:format', :controller => 'blogs', :action => 'index'
  map.connect 'projects/:project_id/blogs/:action/:id', :controller => 'blogs', :action => 'show'
end
