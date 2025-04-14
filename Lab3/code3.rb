require 'json'
require 'yaml'

class Recipe
  attr_accessor :name, :ingredients, :steps

  def initialize(name, ingredients, steps)
    @name = name
    @ingredients = ingredients
    @steps = steps
  end

  def to_h
    { ingredients: @ingredients, steps: @steps }
  end
end

class RecipeBook
  attr_accessor :recipes
  def initialize
    @recipes = {}
  end

  def to_h
    data = {}
    @recipes.each do |name, recipe|
      data[name] = recipe.to_h
    end
    data
  end

  def add_recipe(recipe)
    @recipes[recipe.name] = recipe
    puts "Recipe \"#{recipe.name}\" added successfully."
  end

  def update_recipe(old_name, new_name: nil, new_ingredients: nil, new_steps: nil)
    if @recipes.key?(old_name)
      recipe = @recipes[old_name]
      recipe.name = new_name if new_name && !new_name.empty?
      recipe.ingredients = new_ingredients if new_ingredients
      recipe.steps = new_steps if new_steps
      if new_name && new_name != old_name
        @recipes.delete(old_name)
        @recipes[new_name] = recipe
      end
      puts "Recipe updated."
    else
      puts "Recipe not found."
    end
  end

  def remove_recipe(name)
    if @recipes.delete(name)
      puts "Recipe \"#{name}\" deleted."
    else
      puts "Recipe not found."
    end
  end

  def show_recipes
    if @recipes.empty?
      puts "Your recipe collection is empty."
    else
      puts "\nYour recipes:"
      @recipes.each do |name, recipe|
        puts "- #{name}:"
        puts "  Ingredients: #{recipe.ingredients.join(', ')}"
        puts "  Steps:"
        recipe.steps.each_with_index { |step, i| puts "    #{i + 1}. #{step}" }
      end
    end
  end

  def save_to_file(filename)
    case File.extname(filename).downcase
    when '.json'
      File.write(filename, JSON.pretty_generate(to_h))
      puts "Recipes saved to \"#{filename}\" in JSON format."
    when '.yaml', '.yml'
      File.write(filename, recipe.to_yaml)
      puts "Recipes saved to \"#{filename}\" in YAML format."
    else
      puts "Unsupported file format. Only JSON and YAML are supported."
    end
  end

  def load_from_file(filename)
    unless File.exist?(filename)
      puts "File not found."
      return
    end

    data =
      case File.extname(filename).downcase
      when '.json'
        JSON.parse(File.read(filename), symbolize_names: true)
      when '.yaml', '.yml'
        YAML.load_file(filename) || {}
      else
        puts "Unsupported file format."
        return
      end

    data.each do |name, details|
      recipe = Recipe.new(name, details[:ingredients], details[:steps])
      @recipes[name] = recipe
    end

    puts "Recipes loaded from \"#{filename}\"."
  end
end

book = RecipeBook.new

def menu
  puts "\nChoose an action:"
  puts "1. View all recipes"
  puts "2. Add a recipe"
  puts "3. Update a recipe"
  puts "4. Delete a recipe"
  puts "5. Save to file"
  puts "6. Load from file"
  puts "7. Exit"
end

loop do
  menu
  print "Your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    book.show_recipes
  when 2
    print "Enter recipe name: "
    name = gets.chomp
    print "Enter ingredients (comma-separated): "
    ingredients = gets.chomp.split(',').map(&:strip)
    print "Enter steps (one per line, type 'END' to finish):\n"
    steps = []
    while (step = gets.chomp) != 'END'
      steps << step
    end
    recipe = Recipe.new(name, ingredients, steps)
    book.add_recipe(recipe)
  when 3
    print "Enter the name of the recipe to update: "
    old_name = gets.chomp
    print "New name (press Enter to keep the same): "
    new_name = gets.chomp
    print "New ingredients (comma-separated, press Enter to keep the same): "
    new_ingredients = gets.chomp
    new_ingredients = new_ingredients.empty? ? nil : new_ingredients.split(',').map(&:strip)
    print "New steps (one per line, type 'END' to finish or to keep the same):\n"
    new_steps = []
    while (step = gets.chomp) != 'END'
      new_steps << step
    end
    new_steps = new_steps.empty? ? nil : new_steps
    book.update_recipe(old_name, new_name: new_name.empty? ? nil : new_name,
                       new_ingredients: new_ingredients, new_steps: new_steps)
  when 4
    print "Enter the name of the recipe to delete: "
    name = gets.chomp
    book.remove_recipe(name)
  when 5
    print "Enter filename to save: "
    filename = gets.chomp
    book.save_to_file(filename)
  when 6
    print "Enter filename to load: "
    filename = gets.chomp
    book.load_from_file(filename)
  when 7
    puts "Goodbye!"
    break
  else
    puts "Invalid choice, please try again."
  end
end

