class AddWpmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wpm, :integer
  end
end
