class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, dependent: :destroy

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true,
    reject_if: proc { |attrs| attrs['ingredient_name'].blank? && attrs['quantity'].blank? && attrs['unit'].blank? }

  accepts_nested_attributes_for :steps, allow_destroy: true,
    reject_if: proc { |attrs| attrs['description'].blank? }

  validates :name, :description, presence: true
  validate :must_have_at_least_one_ingredient
  validate :must_have_at_least_one_step


  private

  def must_have_at_least_one_ingredient
    valid_ingredients = recipe_ingredients.reject do |ri|
      ri.marked_for_destruction? || (ri.ingredient_name.blank? && ri.quantity.blank? && ri.unit.blank?)
    end
    errors.add(:base, "Потрібен хоча б один інгредієнт") if valid_ingredients.empty?
  end

  def must_have_at_least_one_step
    valid_steps = steps.reject { |step| step.marked_for_destruction? || step.description.blank? }
    errors.add(:base, "Потрібен хоча б один крок приготування") if valid_steps.empty?
  end

  
end
