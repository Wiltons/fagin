class AddTimeAddedPocketToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :time_added_pocket, :integer
  end
end
