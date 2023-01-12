class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :component
      t.string :image, null: false
      t.string :tag_list
      t.string :recipe_id, null: false


      t.timestamps
    end
  end
end
