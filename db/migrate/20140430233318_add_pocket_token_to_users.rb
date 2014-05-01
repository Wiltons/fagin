class AddPocketTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pocket_token, :string
  end
end
