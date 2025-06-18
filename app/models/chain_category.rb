class ChainCategory < ApplicationRecord
  has_many :chains, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
