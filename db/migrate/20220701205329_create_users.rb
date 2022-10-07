class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      t.string :first_name, :default => ""
      t.string :last_name, :default => ""
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.text :description, :default => ""
      t.string :user_image

      t.timestamps null: false
    end
  end
end
