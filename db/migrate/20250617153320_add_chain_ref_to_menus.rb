class AddChainRefToMenus < ActiveRecord::Migration[8.0]
  def change
    add_reference :menus, :chain, null: false, foreign_key: true, index: true
  end
end
