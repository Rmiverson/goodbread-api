# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_01_065334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "header"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "recipe_images", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.text "description"
    t.string "image"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_images_on_recipe_id"
  end

  create_table "recipe_likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_likes_on_recipe_id"
    t.index ["user_id"], name: "index_recipe_likes_on_user_id"
  end

  create_table "recipe_ordered_lists", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "header"
    t.string "content", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_ordered_lists_on_recipe_id"
  end

  create_table "recipe_texts", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "header"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_texts_on_recipe_id"
  end

  create_table "recipe_unordered_lists", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "header"
    t.string "content", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_unordered_lists_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "board_id", null: false
    t.bigint "subboard_id", null: false
    t.string "title"
    t.text "description"
    t.string "banner_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_recipes_on_board_id"
    t.index ["subboard_id"], name: "index_recipes_on_subboard_id"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "subboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "header"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subboards_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_tags_on_recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.text "description"
    t.string "user_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "boards", "users"
  add_foreign_key "recipe_images", "recipes"
  add_foreign_key "recipe_likes", "recipes"
  add_foreign_key "recipe_likes", "users"
  add_foreign_key "recipe_ordered_lists", "recipes"
  add_foreign_key "recipe_texts", "recipes"
  add_foreign_key "recipe_unordered_lists", "recipes"
  add_foreign_key "recipes", "boards"
  add_foreign_key "recipes", "subboards"
  add_foreign_key "recipes", "users"
  add_foreign_key "subboards", "users"
  add_foreign_key "tags", "recipes"
end
