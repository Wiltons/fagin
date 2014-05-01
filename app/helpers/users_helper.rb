module UsersHelper

  # returns the Gravatar for a user
  def gravatar_for(user, options = {size: 50})
    if user.email
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end

  def populate_articles(user, options={since:"1000000000"})
    uri=URI('https://getpocket.com/v3/get')
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' => 'application/json'})
    req.body={"consumer_key" => ENV['pocket_key'],
              "access_token" => user.pocket_token,
              "count" => "2",
              "since" => options[:since] }.to_json
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.verify_mode= OpenSSL::SSL::VERIFY_NONE
      http.ssl_version= :SSLv3
      http.request req
    end
    article = JSON[res.body]
=begin
    article["list"].each do |key, value|
      user.articles.build(
        item_id: key,
        given_url: value["given_url"],
        favorite: value["favorite"] ,
        given_title: value["given_title"]
      )
    end
    return article
=end
  end


end
