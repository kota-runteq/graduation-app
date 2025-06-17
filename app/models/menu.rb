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

  NUTRIENT_OPS = {
    ">=" => :gteq,
    "<=" => :lteq,
    ">"  => :gt,
    "<"  => :lt,
    "="  => :eq
  }.freeze

  %i[protein fat carbs calories].each do |nutrient|
    define_singleton_method("#{nutrient}_gteq") do |v = nil|
      v.to_s.strip.empty? ? all : nutrient_amount_cond(nutrient.to_s, ">=", v)
    end

    define_singleton_method("#{nutrient}_lteq") do |v = nil|
      v.to_s.strip.empty? ? all : nutrient_amount_cond(nutrient.to_s, "<=", v)
    end
  end


  def self.nutrient_amount_cond(key, op, val)
    arel_method = NUTRIENT_OPS[op]
    raise ArgumentError, "Invalid operator: #{op}" unless arel_method
    mnt  = MenuNutrient.arel_table
    condition = mnt[:amount].public_send(arel_method, val)
    joins(menu_nutrients: :nutrient)
      .where(nutrients: { key: key })
      .where(condition)
  end
end
