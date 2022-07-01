class CreateSubFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_folders do |t|
      t.references :folder, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
