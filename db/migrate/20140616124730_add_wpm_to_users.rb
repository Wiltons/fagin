class AddWpmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wpm, :integer, :default => 200
  end
end
