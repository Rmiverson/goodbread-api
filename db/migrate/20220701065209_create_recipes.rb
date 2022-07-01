class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.references :subboard, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :banner_image

      t.timestamps
    end
  end
end
