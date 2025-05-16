class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.integer :cooking_time

      t.timestamps
    end
  end
end
