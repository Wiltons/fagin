class User < ActiveRecord::Base
  has_many :fetches, dependent: :destroy
  has_many :pushes, dependent: :destroy
  has_many :articles
  has_many :tags, through: :articles
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

  def count_articles
    numArticles = 0
    fetches.each do |f|
      numArticles += f.articles.count
    end
    return numArticles
  end

  def get_tags
    @tags = Array.new
    self.tags.each do |t|
      @tags << t.name
    end
    return @tags
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
