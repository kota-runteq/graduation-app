# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require_relative 'seeds/nutrients'
require 'csv'

CSV.read(Rails.root.join('db/data/chain_categories.csv'), headers: true)
   .reject { |row| row['name'].nil? }
   .each do |row|
  ChainCategory.find_or_create_by!(name: row['name'])
end

CSV.read(Rails.root.join('db/data/chains.csv'), headers: true)
   .reject { |row| row['name'].nil? || row['chain_category_name'].nil? }
   .each do |row|
  category = ChainCategory.find_by!(name: row['chain_category_name'])
  Chain.find_or_create_by!(name: row['name'], chain_category: category)
end

Dir[Rails.root.join('db/data/menus/*.csv')].each do |file_path|
  key   = File.basename(file_path, '.csv')
  chain = Chain.find_by!(name: key)
  CSV.foreach(file_path, headers: true) do |row|
    menu = chain.menus.find_or_create_by!(name: row['menu_name'].strip)
    {
      'Calories' => row['calories'].delete(',').to_f,
      'Protein'  => row['protein_g'].delete(',').to_f,
      'Fat'      => row['fat_g'].delete(',').to_f,
      'Carbs'    => row['carbs_g'].delete(',').to_f
    }.each do |nutrient_name, amount|
      nutrient = Nutrient.find_by!(name: nutrient_name)
      menu.menu_nutrients.create_with(amount: amount).find_or_create_by!(nutrient: nutrient)
    end
  end
end
