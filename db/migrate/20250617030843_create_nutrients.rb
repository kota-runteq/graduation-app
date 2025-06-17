class CreateNutrients < ActiveRecord::Migration[8.0]
  def change
    create_table :nutrients do |t|
      t.string :key,  null: false
      t.string :name, null: false
      t.string :unit, null: false

      t.timestamps
    end
    
    add_index :nutrients, :key, unique: true
  end
end
