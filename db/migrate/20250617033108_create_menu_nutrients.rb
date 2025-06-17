class CreateMenuNutrients < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_nutrients do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :nutrient, null: false, foreign_key: true
      t.decimal :amount, precision: 5, scale: 1, null: false

      t.timestamps
    end

    add_index :menu_nutrients, %i[menu_id nutrient_id], unique: true
    add_index :menu_nutrients, %i[nutrient_id amount]
  end
end
