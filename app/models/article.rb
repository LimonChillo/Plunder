class Article < ActiveRecord::Base
  # destroy fails due to dependencies!
  # has_many :matches, :dependent => :destroy

  has_many :users, :through => :matches
  #has_many :exchanges, :as => :exchange_owner, :dependent => :destroy
  belongs_to :user

  has_attached_file :avatar, styles: { large: "600x600", medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :name, presence: true

  scope :user_of_current_match, ->(current_match) {
      where(id: current_match.favorite_id).pluck(:user_id).first
  }
  scope :unless, ->(id) {
      where.not(user_id: id)
  }

  def self.my_articles_matched_by_other_user(user_of_current_match, current)
    matches_of_other_user = Match.where(user_id: user_of_current_match).where(like: true).all.pluck(:favorite_id)
    Article.where(id: matches_of_other_user).where(user_id: current).all
  end

end