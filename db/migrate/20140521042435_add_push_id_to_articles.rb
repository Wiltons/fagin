class AddPushIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :push_id, :integer
  end
end
