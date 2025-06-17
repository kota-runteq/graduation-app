class Menu < ApplicationRecord
  class Menu < ApplicationRecord
  validates :name, presence: true

  has_many :menu_nutrients, dependent: :destroy
  has_many :nutrients, through: :menu_nutrients
  end
end
