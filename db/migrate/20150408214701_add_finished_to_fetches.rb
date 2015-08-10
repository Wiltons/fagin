class AddFinishedToFetches < ActiveRecord::Migration
  def change
    add_column :fetches, :finished, :boolean
  end
end
