class User < ActiveRecord::Base
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def User.create_with_omniauth(auth)
    create! do |user|
      user.uid=auth["uid"]
    end
  end

  def feed
    # This is preliminary
    Micropost.where("user_id = ?", id)
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
