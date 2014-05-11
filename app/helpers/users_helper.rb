module UsersHelper

  # returns the Gravatar for a user
  def gravatar_for(user, options = {size: 50})
    if user.email
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.uid, class: "gravatar")
    end
  end

end
