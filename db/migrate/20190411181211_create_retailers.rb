class CreateRetailers < ActiveRecord::Migration[5.2]
  def change
    create_table :retailers do |t|
      t.string :name
    end
  end
end
