class CreateIndex < ActiveRecord::Migration
  def up
    add_index :matches, :favorite_id
    add_index :matches, :user_id
    add_index :exchanges, :article_id_1
    add_index :exchanges, :article_id_2
    add_index :exchanges, :user_1
    add_index :exchanges, :user_2
    add_index :exchanges, :user_1_accept
    add_index :exchanges, :user_2_accept
  end

  def down
    remove_index :matches, :favorite_id
    remove_index :matches, :user_id
    remove_index :exchanges, :article_id_1
    remove_index :exchanges, :article_id_2
    remove_index :exchanges, :user_1
    remove_index :exchanges, :user_2
    remove_index :exchanges, :user_1_accept
    remove_index :exchanges, :user_2_accept
  end
end
