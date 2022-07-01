class CreateSubboards < ActiveRecord::Migration[7.0]
  def change
    create_table :subboards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :header
      t.text :description
      
      t.timestamps
    end
  end
end
