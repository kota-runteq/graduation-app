class Nutrient < ApplicationRecord
  validates :key,  presence: true, uniqueness: true
  validates :name, presence: true
  validates :unit, presence: true

  has_many :menu_nutrients, dependent: :destroy
  has_many :menus, through: :menu_nutrients
end
