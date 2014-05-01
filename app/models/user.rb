class User < ActiveRecord::Base
  has_many :articles
  before_create :create_remember_token
  before_save {self.email=email.downcase unless self.email.nil?}
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, allow_blank: true,
                    format:   { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.pocket_token=auth["credentials"]["token"]
    end
  end

  def User.populate_articles(options={since:"1000000000"})
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'], 
              "access_token" => user.pocket_token, 
              "count" => "10" }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
