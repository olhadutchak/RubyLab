class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end