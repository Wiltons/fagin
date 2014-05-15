class Fetch < ActiveRecord::Base
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :user_id,     presence: true
  validates :full_fetch,  presence: true

  def populate_articles
    since = params[:since].nil? ? 1000000000 : params[:since]
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'],
              "access_token" => current_user.pocket_token,
              "since" => since }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end
    article = JSON[res.body]
    current_user.last_fetch=Time.now.to_i
    current_user.save
    article["list"].each do |key, value|
      @article = current_user.articles.build(
                  item_id: key,
                  given_url: value["given_url"],
                  favorite: value["favorite"],
                  status: value["status"],
                  #given_title: value["given_title"],
                  word_count: value["word_count"])
      @article.save
    end
    if article["list"].blank?
      flash[:notice] = "No new articles saved since last fetch"
    else
      flash[:success] = "New articles fetched!"
    end
    redirect_to root_path
  end

end
