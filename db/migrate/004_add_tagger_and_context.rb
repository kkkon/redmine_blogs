class AddTaggerAndContext < ActiveRecord::Migration
  require_dependency 'acts_as_taggable_on/tagging'

  def self.up
    add_column :taggings, :context, :string unless column_exists? :taggings, :context
    add_column :taggings, :tagger_id, :integer unless column_exists? :taggings, :tagger_id
    add_column :taggings, :tagger_type, :string unless column_exists? :taggings, :tagger_type

    add_index :taggings, [:taggable_id, :taggable_type, :context] unless index_exists? :taggings, [:taggable_id, :taggable_type, :context]

    ActsAsTaggableOn::Tagging.update_all("context = 'tags'", "context = NULL")
  end

  def self.down
    remove_column :taggings, :context
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
  end
end
