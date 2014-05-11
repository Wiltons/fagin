class AddLastFetchTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_fetch, :integer
  end
end
