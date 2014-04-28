class User < ActiveRecord::Base
  before_create :create_remember_token
  #before_save {self.email=email.downcase}
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
    end
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
