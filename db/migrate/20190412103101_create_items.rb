class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.date :date
      t.string :name
      t.references :category, foreign_key: true
    end
  end
end
