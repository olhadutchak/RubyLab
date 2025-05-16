class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true
  def self.cleanup_unused
  left_joins(:recipe_ingredients).where(recipe_ingredients: { id: nil }).destroy_all
end
end
