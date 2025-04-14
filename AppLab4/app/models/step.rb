class Step < ApplicationRecord
  belongs_to :recipe

  validates :description, presence: true
  validates :position, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }
  validates :position, uniqueness: { scope: :recipe_id, message: "має бути унікальною для рецепта" }

  default_scope { order(:position) } 
end