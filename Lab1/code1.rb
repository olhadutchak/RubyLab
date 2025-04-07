require 'json'
require 'yaml'

recipes = {}

def add_recipe(recipes, name, ingredients, steps)
  recipes[name] = { 
    ingredients: ingredients, 
    steps: steps 
  }
end

def edit_recipe(recipes, name, ingredients: nil, steps: nil)
  return "Recipe not found" unless recipes.key?(name)
  
  recipes[name][:ingredients] = ingredients if ingredients
  recipes[name][:steps] = steps if steps
  
  "Recipe updated"
end

def delete_recipe(recipes, name)
  recipes.delete(name) ? "Recipe deleted" : "Recipe not found"
end

def search_recipe(recipes, name)
  recipes.key?(name) ? recipes[name] : "Recipe not found"
end

def save_to_json(recipes, file_name)
  File.write(file_name, JSON.pretty_generate(recipes)) 
  "Recipes saved to #{file_name}"
end

def load_from_json(file_name)
  File.exist?(file_name) ? JSON.parse(File.read(file_name), symbolize_names: true) : {}
end

def save_to_yaml(recipes, file_name)
  File.write(file_name, recipes.to_yaml)
  "Recipes saved to #{file_name}"
end

def load_from_yaml(file_name)
  File.exist?(file_name) ? YAML.load(File.read(file_name), symbolize_names: true) : {}
end

def print_recipes(recipes)
  recipes.each do |name, details|
    puts "\n#{name}"
    puts "Ingredients: #{details[:ingredients].join(', ')}"
    puts "Steps:"
    details[:steps].each_with_index { |step, index| puts "  #{index + 1}. #{step}" }
    puts "-" * 40
  end
end

add_recipe(recipes, "Pasta Carbonara", ["Spaghetti", "Bacon", "Eggs", "Parmesan cheese", "Garlic", "Salt", "Pepper"], 
["Boil spaghetti", "Fry bacon", "Mix eggs with cheese", "Combine everything and heat up"])
add_recipe(recipes, "Omelette", ["Eggs", "Milk", "Salt", "Oil"], 
["Whisk eggs", "Fry the mixture", "Serve hot"])
add_recipe(recipes, "Gazpacho Soup", ["Tomatoes", "Cucumbers", "Bell pepper", "Garlic", "Olive oil", "Vinegar", "Salt", "Pepper"], 
["Chop vegetables", "Blend everything", "Chill before serving"])
add_recipe(recipes, "Caesar Salad", ["Lettuce", "Chicken", "Croutons", "Parmesan cheese", "Caesar dressing"], 
["Grill chicken", "Toss ingredients together", "Serve with dressing"])
add_recipe(recipes, "Pancakes", ["Flour", "Milk", "Eggs", "Sugar", "Butter"], 
["Mix ingredients", "Pour batter onto a pan", "Flip and cook", "Serve with syrup"])

puts delete_recipe(recipes, "Borscht")

puts edit_recipe(recipes, "Omelette", ingredients: ["Eggs", "Milk", "Salt", "Oil", "Parsley"])
puts search_recipe(recipes, "Gazpacho Soup")

save_to_json(recipes, "recipes.json")
save_to_yaml(recipes, "recipes.yaml")

loaded_json = load_from_json("recipes1.json")
loaded_yaml = load_from_yaml("recipe1.yaml")

puts "\nSaved recipes json:"
print_recipes(loaded_json)

puts "\nSaved recipes yaml:"
print_recipes(loaded_yaml)
