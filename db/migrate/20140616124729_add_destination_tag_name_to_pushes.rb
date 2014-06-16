class AddDestinationTagNameToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :destination_tag_name, :string
  end
end
