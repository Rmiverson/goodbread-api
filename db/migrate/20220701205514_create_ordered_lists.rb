class CreateOrderedLists < ActiveRecord::Migration[7.0]
  def change
    create_table :ordered_lists do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :title, null: false
      t.string :list_items, :array => true
      t.integer :index_order, null: false
      
      t.timestamps
    end
  end
end
