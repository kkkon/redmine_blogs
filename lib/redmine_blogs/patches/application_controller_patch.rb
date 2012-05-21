module RedmineBlogs
  module Patches
    module ApplicationControllerPatch
      extend ActiveSupport::Concern

      included do
        class_eval do
          unloadable
          helper :tags
        end
      end

      module ClassMethods
      end
    end
  end
end
