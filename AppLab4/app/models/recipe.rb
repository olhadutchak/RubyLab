class Recipe < ApplicationRecord
  has_and_belongs_to_many :ingredients
  has_many :steps, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end
