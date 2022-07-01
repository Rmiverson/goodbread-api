class RecipeFolderJoin < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_folder_join do |t|
      t.references :folder, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
