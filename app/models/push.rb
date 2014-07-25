class Push < ActiveRecord::Base
  belongs_to :user
  has_many :articles
  validates :article_length, presence: true
  validates_uniqueness_of :article_length, 
    scope: [:user_id, :source_tag_name, :destination_tag_name]

  def tag_articles
    items = collect_articles

    # Prepare the Pocket modify URL
    # This looks like, and likely is, a crappy hack job
    uri=URI('https://getpocket.com/v3/send')
    req = Net::HTTP::Post.new(uri.path)

    actions = Array.new

    # Create the array of actions
    items.each do |item|
      actions << {"action" => "tags_add",
                  "item_id" => "#{item}",
                  "tags" => self.destination_tag_name
      }
    end

    # Append the query string to the base url
    req.path << "?"
    req.path << { "access_token" => user.pocket_token,
                  "actions" => actions.to_json,
                  "consumer_key" => ENV['pocket_key']
                }.to_query
    # Send the modify string to Pocket
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end

  end

  def collect_articles
    items = Array.new
    user.articles.each do |a|
      if self.comparator=='Over'
        items << a.item_id if a.word_count > (self.article_length * user.wpm)
      elsif self.comparator=='Under'
        items << a.item_id if a.word_count < (self.article_length * user.wpm)
      end
    end
    return items
  end
end
