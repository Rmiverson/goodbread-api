class CreateRecipeImages < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_images do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :description
      t.string :image
      t.string :image_url
      
      t.timestamps
    end
  end
end
