class AddUserIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :user_id, :integer
    add_index :articles, [:item_id, :user_id], name: 'article_pk', unique: true
  end
end
