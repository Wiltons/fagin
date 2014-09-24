class AddIndexToPushes < ActiveRecord::Migration
  def change
    add_index :pushes, [:user_id, :source_tag_name, 
      :destination_tag_name, :comparator, :article_length], 
      name: 'pushes_pk', unique: true
  end
end
