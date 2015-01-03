class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :product_id
      t.integer :partner_id

      t.timestamps null: false
    end
  end
end
