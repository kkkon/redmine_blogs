ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'blogs' do |blogs|
    blogs.connect 'projects/:project_id/blogs/new', :action => 'new'
    blogs.connect 'projects/:project_id/blogs.:format', :action => 'index'
    blogs.connect 'blogs/users/:id/:project_id', :action => 'index'
    blogs.connect 'blogs/tags/:id/:project_id', :action => 'show_by_tag'
    blogs.connect 'blogs/get_tag_list', :action => 'get_tag_list'
    blogs.connect 'blogs/preview', :action => 'preview'
    blogs.connect 'blogs/:id', :action => 'show'
    blogs.connect 'blogs/:id/edit', :action => 'edit'
    blogs.connect 'blogs/:id/destroy', :action => 'destroy', :conditions => {:method => :post}
    blogs.connect 'blogs/:id/comments/:comment_id', :action => 'destroy_comment', :conditions => {:method => :delete}
  end
end
