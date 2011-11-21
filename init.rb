require 'redmine'

Dir[File.join(directory,'vendor','plugins','*')].each do |dir|
  path = File.join(dir, 'lib')
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :redmine_blogs do
  require_dependency 'comment'
  Comment.send(:include, RedmineBlogs::Patches::CommentPatch)

  require_dependency 'application_controller'
  ApplicationController.send(:include, RedmineBlogs::Patches::ApplicationControllerPatch)

  require_dependency 'application_helper' 
  ApplicationHelper.send(:include, RedmineBlogs::Patches::ApplicationHelperGlobalPatch)

  require_dependency 'acts_as_taggable'
end

Redmine::Plugin.register :redmine_blogs do
  name 'Redmine Blogs plugin'
  author 'A. Chaika, Kyanh, Eric Davis'
  description 'Redmine Blog plugin'
  version '0.2.0-edavis10'

  project_module :blogs do
    permission :manage_blogs, :blogs => [:new, :edit, :destroy_comment, :destroy]
    permission :comment_blogs, :blogs => :add_comment
    permission :view_blogs, :blogs => [:index, :show, :show_by_tag, :history]
  end

  menu :project_menu, :blogs, {:controller => 'blogs', :action => 'index'},
       :caption => 'Blogs', :after => :news, :param => :project_id

  activity_provider :blogs
end

class RedmineBlogsHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag 'stylesheet', :plugin => 'redmine_blogs' %>"
end 

require 'redmine_blogs/hooks/view_account_left_middle_hook'
