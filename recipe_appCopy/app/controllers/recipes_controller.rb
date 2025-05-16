class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy]

  def index
    @recipes = Recipe.all
  end

  def show
   
  end

  def new
    @recipe = Recipe.new
    3.times { @recipe.recipe_ingredients.build }
    3.times { @recipe.steps.build }
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: "Рецепт успішно створено!"
    else
      flash.now[:alert] = @recipe.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    3.times { @recipe.recipe_ingredients.build } if @recipe.recipe_ingredients.empty?
    3.times { @recipe.steps.build } if @recipe.steps.empty?
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Рецепт успішно оновлено!"
    else
      flash.now[:alert] = "Помилка оновлення рецепта"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @recipe.destroy
  Ingredient.cleanup_unused
  redirect_to recipes_path, notice: "Рецепт видалено."
end

def new_ingredient_field
    @ri = RecipeIngredient.new
    @index = params[:index]

    form_builder = ActionView::Helpers::FormBuilder.new(
      "recipe[recipe_ingredients_attributes][#{@index}]",
      @ri,
      view_context,
      {}
    )

    render partial: 'recipe_ingredient_fields', locals: { f: form_builder }
  end

   def new_step_field
    @step = Step.new
    render partial: 'step_fields', locals: { f: nil, step: @step, index: params[:index] }
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

 def recipe_params
  params.require(:recipe).permit(
    :name, :description,
    recipe_ingredients_attributes: [:id, :ingredient_name, :quantity, :unit, :_destroy],
    steps_attributes: [:id, :description, :_destroy]
  )
end
end
