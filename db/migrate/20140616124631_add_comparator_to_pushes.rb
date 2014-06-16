class AddComparatorToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :comparator, :string
  end
end
