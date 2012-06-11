require 'redmine'

# Patches to the Redmine core.
Rails.configuration.to_prepare do
  require_dependency 'comment'
  Comment.send(:include, RedmineBlogs::Patches::CommentPatch)

  require_dependency 'application_controller'
  ApplicationController.send(:include, RedmineBlogs::Patches::ApplicationControllerPatch)

  require_dependency 'application_helper'
  ApplicationHelper.send(:include, RedmineBlogs::Patches::ApplicationHelperGlobalPatch)

  require_dependency 'acts_as_taggable_on'
end

Redmine::Plugin.register :redmine_blogs do
  name 'Redmine Blogs plugin'
  author 'A. Chaika, Kyanh, Eric Davis'
  description 'Redmine Blog plugin'
  version '0.3.0'
  requires_redmine :version_or_higher => '2.0.0'

  project_module :blogs do
    permission :manage_blogs, {:blogs => [:new, :edit, :destroy_comment, :destroy]}, :require => :member
    permission :comment_blogs, {:blogs => :add_comment}
    permission :view_blogs, {:blogs => [:index, :preview, :show, :show_by_tag, :history]}
  end

  menu :project_menu, :blogs, {:controller => 'blogs', :action => 'index'},
       :caption => 'Blogs', :after => :news, :param => :project_id

  activity_provider :blogs

  Redmine::Search.register :blogs
end

#class RedmineBlogsHookListener < Redmine::Hook::ViewListener
#  render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag 'stylesheet', :plugin => 'redmine_blogs' %>"
#end

require 'redmine_blogs/hooks/view_account_left_middle_hook'
