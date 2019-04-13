class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :retailer, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :quantity
      t.decimal :unit_cost
    end
  end
end
