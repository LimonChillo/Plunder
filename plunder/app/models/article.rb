class Article < ActiveRecord::Base
	has_many :matches
  	has_many :users, :through => :matches
  	
  	belongs_to :user
end
