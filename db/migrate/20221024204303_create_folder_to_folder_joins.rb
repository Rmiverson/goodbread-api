class CreateFolderToFolderJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_to_folder_joins do |t|
      t.integer :parent_folder_id
      t.integer :child_folder_id
      
      t.timestamps
    end
  end
end
