class ActsAsTaggable < ActiveRecord::Migration
  def self.up
    unless table_exists? :tags
      create_table :tags do |t|
        t.column :name, :string
      end
    else
      add_column :tags, :name, :string unless column_exists? :tags, :name
    end

    unless table_exists? :taggings
      create_table :taggings do |t|
        t.column :tag_id, :integer
        t.column :taggable_id, :integer

        # You should make sure that the column created is
        # long enough to store the required class names.
        t.column :taggable_type, :string

        t.column :created_at, :datetime
      end
    else
      add_column :taggings, :tag_id, :integer unless column_exists? :taggings, :tag_id
      add_column :taggings, :taggable_id, :integer unless column_exists? :taggings, :taggable_id

      # You should make sure that the column created is
      # long enough to store the required class names.
      add_column :taggings, :taggable_type, :string unless column_exists? :taggings, :taggable_type

      add_column :taggings, :created_at, :datetime unless column_exists? :taggings, :created_at
    end

    add_index :taggings, :tag_id unless index_exists? :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type] unless index_exists? :taggings, [:taggable_id, :taggable_type]
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
