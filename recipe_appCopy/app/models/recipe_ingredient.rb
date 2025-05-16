class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient, optional: true

  before_validation :assign_ingredient_by_name

  def ingredient_name
  ingredient.name if ingredient
end

def ingredient_name=(name)
  return if name.blank?

  existing_ingredient = Ingredient.find_by(name: name.strip)
  if existing_ingredient
    self.ingredient = existing_ingredient
  else
    self.ingredient = Ingredient.create(name: name.strip)
  end
end
  private

  def assign_ingredient_by_name
  return if @ingredient_name.blank?

  if ingredient.present?
    if ingredient.name != @ingredient_name.strip
      ingredient.update(name: @ingredient_name.strip)
    end
  else
    self.ingredient = Ingredient.find_or_create_by(name: @ingredient_name.strip)
  end
end
end
