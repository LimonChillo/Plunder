class Match < ActiveRecord::Base
	belongs_to :user
	# destroy fails due to dependencies!
  # belongs_to :favorite, :class_name => "Article"

	validates :favorite_id, :presence => true, :uniqueness => { :scope => :user_id }
  validates :user_id, :presence => true

  scope :by, ->(id) {
      where(user_id: id)
  }
  scope :current, ->(id1, id2) {
      where(user_id: id1).where(favorite_id: id2).first
  }
end