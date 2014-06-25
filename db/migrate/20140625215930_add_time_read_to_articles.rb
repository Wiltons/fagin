class AddTimeReadToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :time_read, :integer
  end
end
