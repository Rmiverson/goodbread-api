class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.references :user, null: false, foreign_key: true
      t.string :label, null: false, unique: true
      
      t.timestamps null: false
    end
  end
end
