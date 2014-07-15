class Tag < ActiveRecord::Base
  belongs_to :article
  has_many :users, through: :articles
end
