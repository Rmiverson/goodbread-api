class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :label
      
      t.timestamps
    end
  end
end
