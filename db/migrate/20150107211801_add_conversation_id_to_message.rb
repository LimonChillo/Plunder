

class AddConversationIdToMessage < ActiveRecord::Migration

	def self.up
    	change_table :messages do |t|
      		t.integer :conversation_id
    	end
  	end

  def self.down
  end
end
