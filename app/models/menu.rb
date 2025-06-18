class Menu < ApplicationRecord
  has_many :menu_nutrients, dependent: :destroy
  has_many :nutrients, through: :menu_nutrients
  belongs_to :chain

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

  NUTRIENTS = %w[protein fat carbs calories].freeze

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
    nutrient = Nutrient.find_by!(key: key)
    mnt = MenuNutrient.arel_table
    cond = mnt[:amount].public_send(arel_method, val)
    sub = MenuNutrient.where(nutrient_id: nutrient.id).where(cond).select(:menu_id)
    where(id: sub)
  end


  scope :order_by_nutrient, ->(key, dir = 'asc') do
    return all unless NUTRIENTS.include?(key) && %w[asc desc].include?(dir)
    sql_dir = dir == 'desc' ? 'DESC' : 'ASC'
 
    join_sql = <<~SQL
      INNER JOIN menu_nutrients AS sorting_mn
      ON sorting_mn.menu_id = menus.id
      INNER JOIN nutrients AS sorting_n
      ON sorting_n.id = sorting_mn.nutrient_id
      AND sorting_n.key = #{ActiveRecord::Base.connection.quote(key)}
    SQL
 
    joins(join_sql).order(Arel.sql("sorting_mn.amount #{sql_dir}"))
  end
end
