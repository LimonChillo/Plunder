class Match < ActiveRecord::Base
	belongs_to :article
	belongs_to :partner, :class_name => "Article"
end
