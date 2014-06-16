class AddSourceTagNameToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :source_tag_name, :string
  end
end
