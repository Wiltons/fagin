class Article < ActiveRecord::Base
  belongs_to :fetch
  belongs_to :user
  has_many :tags
  validates :fetch_id,    presence: true
  validates :item_id,     presence: true
  validates :word_count,  presence: true
  validates_uniqueness_of :item_id, :scope => :user_id

  def self.for_item_id_and_fetch(item_id, fetch)
    self.find_or_initialize_by(item_id: item_id, user_id: fetch.user.id) do |article|
      article.fetch = fetch
      article.user = fetch.user
    end
  end

  def assign_pocket_data(pocket_data)
    assign_attributes(
      given_url: pocket_data['given_url'],
      given_title: pocket_data['given_title'],
      favorite: pocket_data['favorite'],
      status: pocket_data['status'],
      word_count: pocket_data['word_count'],
      time_added_pocket: pocket_data['time_added'],
      time_updated_pocket: pocket_data['time_updated'],
      time_read: pocket_data['time_read'],
      time_favorited: pocket_data['time_favorited']
    )
  end

  def tagged?(tag_name)
    tags.exists?(name: tag_name)
  end
end
