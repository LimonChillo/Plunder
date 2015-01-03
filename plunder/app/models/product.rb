class Product < ActiveRecord::Base
	has_many :matches
  	has_many :partners, :through => :matches, :source => :partner
end
