class MenuNutrient < ApplicationRecord
  belongs_to :menu
  belongs_to :nutrient

  validates :menu, presence: true
  validates :nutrient, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :nutrient_id, uniqueness: { scope: :menu_id }
end
