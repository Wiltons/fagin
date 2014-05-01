class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :item_id
      t.string :given_url
      t.string :given_title
      t.boolean :favorite
      t.integer :status
      t.integer :word_count
      t.string :tags
      t.string :user_id

      t.timestamps
    end
    add_index :articles, [:user_id, :item_id]
    add_index :articles, [:created_at]
  end
end
