class Message < ActiveRecord::Base
	belongs_to :conversation

	validates :sender,
          		:presence => true

	validates :text,
          		:presence => true,
          		:format => { :without => /<(.|\n)*?>/,
                       :message => 'No HTML Tags allowed in chat. ' }
end
