class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, dependent: :destroy

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true,
    reject_if: proc { |attrs| attrs['ingredient_name'].blank? && attrs['quantity'].blank? && attrs['unit'].blank? }

  accepts_nested_attributes_for :steps, allow_destroy: true,
    reject_if: proc { |attrs| attrs['description'].blank? }

  validates :name, :description, presence: true
  validate :unique_recipe_content
  # validate :must_have_at_least_one_ingredient
  # validate :must_have_at_least_one_step

  private

  def must_have_at_least_one_ingredient
    valid_ingredients = recipe_ingredients.reject do |ri|
      ri.marked_for_destruction? || (ri.ingredient_name.blank? && ri.quantity.blank? && ri.unit.blank?)
    end
    errors.add(:base, "At least one useful one is needed") if valid_ingredients.empty?
  end

  def must_have_at_least_one_step
    valid_steps = steps.reject { |step| step.marked_for_destruction? || step.description.blank? }
    errors.add(:base, "At least one cooking step is required") if valid_steps.empty?
  end

  def unique_recipe_content
    possible_duplicates = Recipe.where(name: name, description: description).where.not(id: id)

    possible_duplicates.each do |existing_recipe|
      if same_ingredients_and_steps_exist?(existing_recipe)
        errors.add(:base, "Такий рецепт вже існує (з ідентичними інгредієнтами та кроками)")
        break
      end
    end
  end

  def same_ingredients_and_steps_exist?(existing_recipe)
    return false unless existing_recipe
    current_ingredients = recipe_ingredients.reject(&:marked_for_destruction?).map do |ri|
      [ri.ingredient_name.to_s.strip.downcase, ri.quantity.to_s.strip, ri.unit.to_s.strip.downcase]
    end.sort

    existing_ingredients = existing_recipe.recipe_ingredients.map do |ri|
      [ri.ingredient_name.to_s.strip.downcase, ri.quantity.to_s.strip, ri.unit.to_s.strip.downcase]
    end.sort

    return false unless current_ingredients == existing_ingredients
    current_steps = steps.reject(&:marked_for_destruction?).map { |s| s.description.to_s.strip.downcase }.sort
    existing_steps = existing_recipe.steps.map { |s| s.description.to_s.strip.downcase }.sort

    current_steps == existing_steps
  end
end
