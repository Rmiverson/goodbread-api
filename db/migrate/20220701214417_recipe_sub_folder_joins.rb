class RecipeSubFolderJoins < ActiveRecord::Migration[7.0]
  def change
    create_join_table :recipes, :sub_folders do |t|
      t.index [:recipe_id, :sub_folder_id], unique: true
      
      t.timestamps null: false
    end
  end
end
