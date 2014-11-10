class Push < ActiveRecord::Base
  belongs_to :user
  has_many :articles
  validates :article_length, presence: true
  validates :source_tag_name, presence: true
  validates :destination_tag_name, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :destination_tag_name,
    :scope => [:source_tag_name, :user_id, :comparator, :article_length]

  def tag_articles
    articles = collect_articles

    # Prepare the Pocket modify URL
    # This looks like, and likely is, a crappy hack job
    uri=URI('https://getpocket.com/v3/send')
    req = Net::HTTP::Post.new(uri.path)

    actions = Array.new

    # Create the array of actions
    articles.each do |article|
      article.push_id=self.id
      article.save!
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
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :TLSv1
      http.request req
    end
  end

  def collect_articles
    user.articles.select do |a|
      if self.comparator=='Over' and (a.tagged?(self.source_tag_name) or self.source_tag_name=="absolutely_all")
        a.word_count > (self.article_length * user.wpm)
      elsif self.comparator=='Under' and (a.tagged?(self.source_tag_name) or self.source_tag_name=="absolutely_all")
        a.word_count < (self.article_length * user.wpm)
      end
    end
  end

  def push_hash
    push_details=""
    push_details << self.source_tag_name << self.destination_tag_name << self.comparator << self.article_length
    queue_name=Digest::SHA256.hexdigest push_details
  end

  def get_outstanding_jobs
    dj = Delayed::Job.find_by(queue: self.push_hash)
    dj.nil? ? nil : dj
  end

  def undo_commit
    dj = get_outstanding_jobs
    dj.destroy unless dj.nil?
  end
end
