class Push < ActiveRecord::Base
  belongs_to :user
  has_many :articles
  validates :article_length, presence: true
  validates_uniqueness_of :destination_tag_name,
    :scope => [:source_tag_name, :user_id, :comparator, :article_length]

  def tag_articles(commit_to_pocket)
    articles = collect_articles

    # Prepare the Pocket modify URL
    # This looks like, and likely is, a crappy hack job
    uri=URI('https://getpocket.com/v3/send')
    req = Net::HTTP::Post.new(uri.path)

    actions = Array.new

    # Create the array of actions
    articles.each do |article|
      if not commit_pocket_articles
        article.push_id=self.id
        article.save!
      end
      actions << {"action" => "tags_add",
                  "item_id" => "#{article.item_id}",
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
    if commit_to_pocket
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        http.verify_mode= OpenSSL::SSL::VERIFY_NONE
        http.ssl_version= :SSLv3
        http.request req
      end
    else

    end

  end

  private

    def collect_articles
      user.articles.select do |a|
        if self.comparator=='Over' and (a.tagged?(self.source_tag_name) or self.source_tag_name=="absolutely_all")
          a.word_count > (self.article_length * user.wpm)
        elsif self.comparator=='Under' and (a.tagged?(self.source_tag_name) or self.source_tag_name=="absolutely_all")
          a.word_count < (self.article_length * user.wpm)
        end
      end
    end
end
