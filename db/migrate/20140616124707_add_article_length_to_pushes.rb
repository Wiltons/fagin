class AddArticleLengthToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :article_length, :integer
  end
end
