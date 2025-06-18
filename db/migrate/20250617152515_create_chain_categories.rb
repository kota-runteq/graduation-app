class CreateChainCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :chain_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :chain_categories, :name, unique: true
  end
end
