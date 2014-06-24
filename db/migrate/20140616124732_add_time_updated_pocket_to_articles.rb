class AddTimeUpdatedPocketToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :time_updated_pocket, :integer
  end
end
