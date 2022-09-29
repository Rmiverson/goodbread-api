class CreateTextboxes < ActiveRecord::Migration[7.0]
  def change
    create_table :textboxes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :title
      t.string :text_content
      t.integer :index_order, null: false
      t.string :component_type, :default => "textbox"
      
      t.timestamps null: false
    end
  end
end
