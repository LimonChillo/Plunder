require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
    
    def setup
	end
	
	test "conversation with same user" do
		assert !Conversation.create(:user_1_id => 2, :user_2_id => 2).valid?, 'Conversation with yourself possible!'
	end
end
