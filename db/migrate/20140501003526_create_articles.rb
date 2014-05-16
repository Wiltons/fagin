class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :item_id
      t.text :given_url
      t.text :given_title
      t.boolean :favorite
      t.integer :status
      t.integer :word_count
      t.string :tags
      t.integer :fetch_id

      t.timestamps
    end
    add_index :articles, [:fetch_id, :item_id], name: "index_relationships_on_fetch_id_and_item_id", unique: true
    add_index :articles, [:created_at]
  end
end