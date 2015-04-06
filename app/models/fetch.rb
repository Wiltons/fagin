class Fetch < ActiveRecord::Base
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :user_id,     presence: true
  validates_inclusion_of :full_fetch, in: [true, false]

  def populate_articles
    # Retrieve all articles saved or updated since just before the last fetch
    if self.full_fetch or user.fetches.count < 2
      since = nil
    else
      user.fetches.to_a.second.created_at.to_i
    end
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'],
              "access_token" => user.pocket_token,
              "detailType" => 'complete',
              "state" => 'all',
              "contentType" => 'article',
              "since" => since }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :TLSv1
      http.request(req)
    end
    article = JSON[res.body]
    article["list"].each do |key, value|
      art = Article.for_item_id_and_fetch(key, self)
      art.assign_pocket_data(value)
      art.save!
      # Save tags unless there aren't any tags with the article
      unless value["tags"].nil?
        value["tags"].each do |key, value|
          tag=Tag.find_or_create_by_name(key)
          art.tags << tag
          #tag=art.tags.find_or_create_by_name(key)
        end
      end
    end
  end

end
