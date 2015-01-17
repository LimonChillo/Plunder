class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :article_id_1
      t.integer :article_id_2
      t.boolean :user_1
      t.boolean :user_2

      t.timestamps null: false
    end
  end
end
