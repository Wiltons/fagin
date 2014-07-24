class AddIndexToPushes < ActiveRecord::Migration
  def change
    add_index :pushes, [:user_id, :source_tag_name, :destination_tag_name], 
      name: 'pushes_pk'
  end
end
