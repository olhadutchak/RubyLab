class CreateSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :steps do |t|
      t.text :description
      t.integer :position
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
