class CreateJoinTableUsersTags < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :tags do |t|
      t.primary_key :id
      t.index [:user_id, :tag_id], unique: true

      t.timestamps null: false
    end
  end
end
