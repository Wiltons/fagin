class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :item_id
      t.text :given_url
      t.text :given_title
      t.integer :favorite
      t.integer :status
      t.integer :is_article
      t.integer :word_count
      t.integer :fetch_id

      t.timestamps
    end
    add_index :articles, [:created_at]
  end
end
