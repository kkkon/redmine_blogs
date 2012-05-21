RedmineApp::Application.routes.draw do
  match 'projects/:project_id/blogs/new', :to => 'blogs#new'
  match 'projects/:project_id/blogs.:format', :to => 'blogs#index'
  match 'blogs/users/:id/:project_id', :to => 'blogs#index'
  match 'blogs/tags/:id/:project_id', :to => 'blogs#show_by_tag'
  match 'blogs/get_tag_list', :to => 'blogs#get_tag_list'
  match 'blogs/preview', :to => 'blogs#preview'
  match 'blogs/:id', :to => 'blogs#show'
  match 'blogs/:id/edit', :to => 'blogs#edit'
  match 'blogs/:id/destroy', :to => 'blogs#destroy', :via => :post
  match 'blogs/:id/add_comment', :to => 'blogs#add_comment'
  match 'blogs/:id/comments/:comment_id', :to => 'blogs#destroy_comment', :via => :delete
end
