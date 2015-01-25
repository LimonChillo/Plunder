class Message < ActiveRecord::Base
	belongs_to :conversation

	validates :sender,
    :presence => true

	validates :text,
    :presence => true
end