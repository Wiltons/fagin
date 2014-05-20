class Article < ActiveRecord::Base
  belongs_to :fetch
  validates :fetch_id,    presence: true
  validates :item_id,     presence: true, uniqueness: true
  validates :word_count,  presence: true
end
