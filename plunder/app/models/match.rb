class Match < ActiveRecord::Base
	belongs_to :product
	belongs_to :partner, :class_name => "Product"
end
