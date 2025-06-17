class Menu < ApplicationRecord
  has_many :menu_nutrients, dependent: :destroy
  has_many :nutrients, through: :menu_nutrients

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[
      protein_gteq protein_lteq
      fat_gteq fat_lteq
      carbs_gteq carbs_lteq
      calories_gteq calories_lteq
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[menu_nutrients nutrients]
  end

  scope :protein_gteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("protein", ">=", v) }
  scope :protein_lteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("protein", "<=", v) }
  scope :fat_gteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("fat", ">=", v) }
  scope :fat_lteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("fat", "<=", v) }
  scope :carbs_gteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("carbs", ">=", v) }
  scope :carbs_lteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("carbs", "<=", v) }
  scope :calories_gteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("calories", ">=", v) }
  scope :calories_lteq, ->(v = nil) { v.to_s.strip.empty? ? all : nutrient_amount_cond("calories", "<=", v) }

  def self.nutrient_amount_cond(key, op, val)
    joins(menu_nutrients: :nutrient)
      .where(nutrients: { key: })
      .where("menu_nutrients.amount #{op} ?", val)
  end
end
