# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_08_085038) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chain_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_chain_categories_on_name", unique: true
  end

  create_table "chains", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "chain_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_category_id"], name: "index_chains_on_chain_category_id"
    t.index ["name"], name: "index_chains_on_name"
  end

  create_table "menu_nutrients", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "nutrient_id", null: false
    t.decimal "amount", precision: 5, scale: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id", "nutrient_id"], name: "index_menu_nutrients_on_menu_id_and_nutrient_id", unique: true
    t.index ["menu_id"], name: "index_menu_nutrients_on_menu_id"
    t.index ["nutrient_id", "amount"], name: "index_menu_nutrients_on_nutrient_id_and_amount"
    t.index ["nutrient_id"], name: "index_menu_nutrients_on_nutrient_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chain_id", null: false
    t.index ["chain_id"], name: "index_menus_on_chain_id"
    t.index ["name"], name: "index_menus_on_name"
  end

  create_table "nutrients", force: :cascade do |t|
    t.string "key", null: false
    t.string "name", null: false
    t.string "unit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_nutrients_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", limit: 30, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chains", "chain_categories"
  add_foreign_key "menu_nutrients", "menus"
  add_foreign_key "menu_nutrients", "nutrients"
  add_foreign_key "menus", "chains"
end
