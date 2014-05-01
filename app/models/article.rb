class Article < ActiveRecord::Base
  belongs_to :user
  validates :user_id,    presence: true
  validates :item_id,     presence: true
  validates :word_count,  presence: true
end
