class Match < ActiveRecord::Base
	belongs_to :user
	belongs_to :favorite, :class_name => "Article"
end
