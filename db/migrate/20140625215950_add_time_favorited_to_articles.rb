class AddTimeFavoritedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :time_favorited, :integer
  end
end
