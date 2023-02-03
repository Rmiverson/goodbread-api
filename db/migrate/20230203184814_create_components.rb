class CreateComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :components do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :index_order, null: false
      t.string :sub_title
      t.string :text
      t.string :ul_items, :array => true
      t.string :ol_items, :array => true
      t.timestamps null: false
    end
  end
end
