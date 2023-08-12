# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_08_12_000009) do

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message", null: false
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "niche_parameters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "unit"
    t.bigint "niche_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_id"], name: "index_niche_parameters_on_niche_id"
  end

  create_table "niche_progress_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "niche_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_id"], name: "index_niche_progress_groups_on_niche_id"
  end

  create_table "niche_progress_tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "niche_progress_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_progress_group_id"], name: "index_niche_progress_tasks_on_niche_progress_group_id"
  end

  create_table "niches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "info", null: false
    t.string "admin_name", null: false
    t.integer "progress_setting", null: false
    t.integer "parameter_setting", null: false
    t.integer "tag_setting", null: false
    t.integer "nice_setting", null: false
    t.integer "publish_range", null: false
    t.integer "topic_range", null: false
    t.integer "comment_range", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_niches_on_user_id"
  end

  create_table "post_parameters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "value", precision: 10, scale: 2, null: false
    t.bigint "niche_parameter_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_parameter_id"], name: "index_post_parameters_on_niche_parameter_id"
    t.index ["post_id"], name: "index_post_parameters_on_post_id"
  end

  create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.date "posted_at", null: false
    t.integer "nice_count", default: 0, null: false
    t.integer "view_count", default: 0, null: false
    t.bigint "niche_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_id"], name: "index_posts_on_niche_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "progress_rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "rate", precision: 5, scale: 2, null: false
    t.bigint "niche_progress_task_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_progress_task_id"], name: "index_progress_rates_on_niche_progress_task_id"
    t.index ["post_id"], name: "index_progress_rates_on_post_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname", null: false
    t.string "first_name"
    t.string "first_name_kana"
    t.string "last_name"
    t.string "last_name_kana"
    t.string "postal_code"
    t.integer "prefecture_id"
    t.string "city"
    t.string "address"
    t.string "building"
    t.string "phone_number"
    t.date "birth_date"
    t.string "customer_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "niche_parameters", "niches", column: "niche_id"
  add_foreign_key "niche_progress_groups", "niches", column: "niche_id"
  add_foreign_key "niche_progress_tasks", "niche_progress_groups"
  add_foreign_key "niches", "users"
  add_foreign_key "post_parameters", "niche_parameters"
  add_foreign_key "post_parameters", "posts"
  add_foreign_key "posts", "niches", column: "niche_id"
  add_foreign_key "posts", "users"
  add_foreign_key "progress_rates", "niche_progress_tasks"
  add_foreign_key "progress_rates", "posts"
end
