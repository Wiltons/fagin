class CreateFetches < ActiveRecord::Migration
  def change
    create_table :fetches do |t|
      t.boolean :full_fetch
      t.integer :user_id

      t.timestamps
    end
  end
end
