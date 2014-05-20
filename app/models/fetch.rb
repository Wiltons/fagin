class Fetch < ActiveRecord::Base
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :user_id,     presence: true
  validates_inclusion_of :full_fetch, in: [true, false]
  before_save :populate_articles

  def populate_articles
    since = full_fetch ? nil : user.fetches.maximum(:created_at).to_i
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'],
              "access_token" => user.pocket_token,
              "since" => since }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end
    article = JSON[res.body]
    article["list"].each do |key, value|
=begin
      test = Article.find_or_create_by(item_id: key) do |art|
        art.given_url=value["given_url"],
        art.favorite=value["favorite"],
        art.status=value["status"],
        art.word_count=value["word_count"]
        raise test.to_yaml
      end
    end
=end
      @article = articles.build(
                  item_id: key,
                  given_url: value["given_url"],
                  favorite: value["favorite"],
                  status: value["status"],
                  #given_title: value["given_title"],
                  word_count: value["word_count"])
    end
  end

end
