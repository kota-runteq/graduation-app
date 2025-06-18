class Chain < ApplicationRecord
  belongs_to :chain_category
  has_many :menus, dependent: :destroy

  validates :name, presence: true
  def self.ransackable_attributes(auth_object = nil)
    %w[id name chain_category_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[chain_category]
  end
end
