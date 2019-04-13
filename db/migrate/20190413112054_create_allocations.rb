class CreateAllocations < ActiveRecord::Migration[5.2]
  def change
    create_table :allocations do |t|
      t.date :date
      t.references :purchase, foreign_key: true
      t.integer :quantity
    end
  end
end
