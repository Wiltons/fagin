class Push < ActiveRecord::Base
  belongs_to :user
  has_many :articles
  before_save :quick_tag_long

  def quick_tag_long
    uri=URI('https://getpocket.com/v3/send')
    req = Net::HTTP::Post.new(uri.path)
    actions={ "action" => "archive",
              "item_id" => "237938806",
              "time" => "111111111" }.to_json
    req.path << "?"
    req.path << {"actions" => "[#{actions}]",
              "access_token" => user.pocket_token,
              "consumer_key" => ENV['pocket_key']
              }.to_query
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end

    raise res.to_yaml
  end

end
