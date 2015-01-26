class Conversation < ActiveRecord::Base
	has_many :messages, :dependent => :destroy

	validates :user_1_id, :presence => true
	validates :user_2_id, :presence => true
  validate :no_conversation_with_same_user

  scope :by_partners, ->(id1, id2) {
    where(user_1_id: [id1, id2], user_2_id: [id1, id2])
  }

  scope :by_id, ->(id) {
    find(id)
  }


  private
    def no_conversation_with_same_user
    	errors.add(:user_1_id, 'No Conversation with yourself!') if user_1_id == user_2_id
  	end
end