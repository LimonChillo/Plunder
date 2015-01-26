class Match < ActiveRecord::Base
	belongs_to :user
	belongs_to :favorite, :class_name => "Article"

	validates :favorite_id, :presence => true, :uniqueness => { :scope => :user_id }
  	validates :user_id, :presence => true
end