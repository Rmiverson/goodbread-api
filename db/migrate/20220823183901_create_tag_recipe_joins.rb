class CreateTagRecipeJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_recipe_joins do |t|
      t.references :recipe, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps
    end
  end
end
