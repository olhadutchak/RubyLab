require 'json'
require 'yaml'

recipes = {}

def add_recipe(recipes, name, ingredients, steps)
  if recipes.key?(name)
    print "Recipe \"#{name}\" already exists. Are you sure you want to add it again? (y/n): "
    answer = gets.chomp.downcase
    if answer != 'y'
      puts "Recipe not added."
      return
    end
  end
  recipes[name] = { ingredients: ingredients, steps: steps }
  puts "Recipe \"#{name}\" added successfully."
end

def update_recipe_name(recipes, old_name, new_name)
  if recipes.key?(old_name)
    recipes[new_name] = recipes.delete(old_name)
    puts "Recipe name updated from \"#{old_name}\" to \"#{new_name}\"."
  else
    puts "Recipe \"#{old_name}\" not found."
  end
end

def update_recipe_ingredients_and_steps(recipes, name, new_ingredients: nil, new_steps: nil)
  if recipes.key?(name)
    recipes[name][:ingredients] = new_ingredients if new_ingredients
    recipes[name][:steps] = new_steps if new_steps
    puts "Recipe \"#{name}\" updated."
  else
    puts "Recipe \"#{name}\" not found."
  end
end

def remove_recipe(recipes, name)
  if recipes.delete(name)
    puts "Recipe \"#{name}\" deleted."
  else
    puts "Recipe not found."
  end
end

def show_recipes(recipes)
  if recipes.empty?
    puts "Your recipe collection is empty."
  else
    puts "\nYour recipes:"
    recipes.each do |name, details|
      puts "- #{name}:"
      puts "  Ingredients: #{details[:ingredients].join(', ')}"
      puts "  Steps:"
      details[:steps].each_with_index { |step, index| puts "    #{index + 1}. #{step}" }
    end
  end
end

def save_to_file(recipes, filename)
  extension = File.extname(filename).downcase
  case extension
  when '.json'
    File.write(filename, JSON.pretty_generate(recipes))
    puts "Recipes saved to \"#{filename}\" in JSON format."
  when '.yaml', '.yml'
    File.write(filename, recipes.to_yaml)
    puts "Recipes saved to \"#{filename}\" in YAML format."
  else
    puts "Unsupported file format. Only JSON and YAML are supported."
  end
end

def load_from_file(filename)
  extension = File.extname(filename).downcase
  if File.exist?(filename)
    case extension
    when '.json'
      loaded_recipes = JSON.parse(File.read(filename), symbolize_names: true)
    when '.yaml', '.yml'
      loaded_recipes = YAML.load_file(filename) || {}
    else
      puts "Unsupported file format. Only JSON and YAML are supported."
      return {}
    end
    return loaded_recipes
  else
    puts "File not found."
    return {}
  end
end

def menu
  puts "\nChoose an action:"
  puts "1. View all recipes"
  puts "2. Add a recipe"
  puts "3. Update ingredients and steps of a recipe"
  puts "4. Update recipe name"
  puts "5. Delete a recipe"
  puts "6. Save to file"
  puts "7. Load from file"
  puts "8. Exit"
end

loop do
  menu
  print "Your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    show_recipes(recipes)
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
    add_recipe(recipes, name, ingredients, steps)
  when 3
    print "Enter the name of the recipe to update: "
    name = gets.chomp
    print "New ingredients (comma-separated, press Enter to keep the same): "
    new_ingredients = gets.chomp
    new_ingredients = new_ingredients.empty? ? nil : new_ingredients.split(',').map(&:strip)
    print "New steps (one per line, type 'END' to finish, press Enter to keep the same):\n"
    new_steps = []
    while (step = gets.chomp) != 'END'
      new_steps << step
    end
    new_steps = new_steps.empty? ? nil : new_steps
    update_recipe_ingredients_and_steps(recipes, name, new_ingredients: new_ingredients, new_steps: new_steps)
  when 4
    print "Enter the name of the recipe to update: "
    old_name = gets.chomp
    print "Enter the new name for the recipe: "
    new_name = gets.chomp
    update_recipe_name(recipes, old_name, new_name)
  when 5
    print "Enter the name of the recipe to delete: "
    name = gets.chomp
    remove_recipe(recipes, name)
  when 6
    print "Enter filename to save: "
    filename = gets.chomp
    save_to_file(recipes, filename)
  when 7
    print "Enter filename to load: "
    filename = gets.chomp
    loaded_recipes = load_from_file(filename)
    if loaded_recipes.empty?
      puts "No recipes found in \"#{filename}\"."
    else
      recipes.merge!(loaded_recipes)  
      puts "Recipes loaded from \"#{filename}\"."
    end
  when 8
    puts "Goodbye!"
    break
  else
    puts "Invalid choice, please try again."
  end
end
