class Push < ActiveRecord::Base
  belongs_to :user
  has_many :articles
  before_save :quick_tag_long

  def quick_tag_long
    # Get all items IDs for articles over the specified length
    tag_items = Array.new
    user.fetches.each do |fetch|
      fetch.articles.each do |article|
        tag_items << article.item_id if article.word_count > 1000
      end
    end

    # Prepare the Pocket modify URL
    # This looks like, and likely is, a crappy hack job
    uri=URI('https://getpocket.com/v3/send')
    req = Net::HTTP::Post.new(uri.path)

    actions = Array.new

    tag_items.each do |item|
      actions << {"action" => "tags_clear",
                  "item_id" => "#{item}"
      }
    end
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

    raise res.to_yaml

  end

end
