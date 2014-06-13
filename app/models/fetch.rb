class Fetch < ActiveRecord::Base
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :user_id,     presence: true
  validates_inclusion_of :full_fetch, in: [true, false]
  after_save :populate_articles

  def populate_articles
    since = full_fetch ? nil : user.fetches.maximum(:created_at).to_i
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
      http.ssl_version= :SSLv3
      http.request req
    end
    article = JSON[res.body]
    article["list"].each do |key, value|
      art = Article.find_or_initialize_by(item_id: key)
      params = {
        item_id: key,
        given_url: value["given_url"],
        favorite: value["favorite"],
        status: value["status"],
        given_title: value["given_title"],
        word_count: value["word_count"]
      }
      # If the article exists, update it. Otherwise create it
      art.persisted? ? art.update_attributes(params) : art=self.articles.create!(params)
      unless value["tags"].nil?
        value["tags"].each do |key, value|
          art.tags.create!(name: key)
        end
      end
    end
  end

end
