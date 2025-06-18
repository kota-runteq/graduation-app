class CreateChains < ActiveRecord::Migration[8.0]
  def change
    create_table :chains do |t|
      t.string :name, null: false
      t.references :chain_category, null: false, foreign_key: true, index: true

      t.timestamps
    end
    add_index :chains, :name
  end
end
