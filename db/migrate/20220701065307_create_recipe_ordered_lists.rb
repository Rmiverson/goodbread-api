class CreateRecipeOrderedLists < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_ordered_lists do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :header
      t.string :content, :array => true

      t.timestamps
    end
  end
end
