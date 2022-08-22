class RecipeSubFolderJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_sub_folder_joins do |t|
      t.references :sub_folder, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
