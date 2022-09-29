class RecipesFolders < ActiveRecord::Migration[7.0]
  def change
    create_join_table :recipes, :folders do |t|
      t.index [:recipe_id, :folder_id], unique: true
      
      t.timestamps null: false
    end
  end
end
