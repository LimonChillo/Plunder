class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :user_1_id
      t.integer :user_2_id

      t.timestamps null: false
    end
  end
end
