class CreateTagsRecipes < ActiveRecord::Migration[7.0]
  def change
    create_join_table :tags, :recipes do |t|
      t.index [:tag_id, :recipe_id], unique: true

      t.timestamps null: false
    end
  end
end
