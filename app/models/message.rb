class Message < ActiveRecord::Base
	belongs_to :conversation

	validates :sender, :presence => true

	validates :text, :presence => true

  scope :of_conversation, ->(conversation) {
      where(conversation_id: conversation)
  }
end