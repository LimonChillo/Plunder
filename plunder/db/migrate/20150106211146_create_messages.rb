class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text
      t.integer :sender
      t.integer :conversation_id

      t.timestamps null: false
    end
  end
end
