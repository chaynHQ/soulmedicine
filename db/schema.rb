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

ActiveRecord::Schema[7.0].define(version: 2023_09_12_113739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "backups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_backups_on_key", unique: true
  end

  create_table "lesson_reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "course_slug", null: false
    t.string "lesson_slug", null: false
    t.string "reaction_name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "course_slug", "lesson_slug"], name: "index_lesson_reactions_on_user_id_and_course_and_lesson_slug", unique: true
    t.index ["user_id", "course_slug"], name: "index_lesson_reactions_on_user_id_and_course_slug"
    t.index ["user_id"], name: "index_lesson_reactions_on_user_id"
  end

  create_table "progresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "course_slug", null: false
    t.string "lesson_slug", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "course_slug", "lesson_slug"], name: "index_progresses_on_user_id_and_course_slug_and_lesson_slug", unique: true
    t.index ["user_id", "course_slug"], name: "index_progresses_on_user_id_and_course_slug"
    t.index ["user_id"], name: "index_progresses_on_user_id"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "course_slug", null: false
    t.boolean "active", default: false, null: false
    t.string "main_language", null: false
    t.string "other_languages", default: [], null: false, array: true
    t.string "delivery_method", default: "email", null: false
    t.string "days_utc", default: [], null: false, array: true
    t.integer "hours_utc", default: [], null: false, array: true
    t.string "lessons_delivered", default: [], array: true
    t.datetime "last_delivered_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_timezone", default: "UTC"
    t.boolean "disguised", default: false
    t.index ["active"], name: "index_subscriptions_on_active"
    t.index ["user_id", "course_slug"], name: "index_subscriptions_on_user_id_and_course_slug", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_name", null: false
    t.string "firebase_id", null: false
    t.string "email", null: false
    t.boolean "email_verified", default: false
    t.datetime "last_seen_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "terms_accepted", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firebase_id"], name: "index_users_on_firebase_id", unique: true
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "course_slug", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["course_slug"], name: "index_votes_on_course_slug"
    t.index ["user_id", "course_slug"], name: "index_votes_on_user_id_and_course_slug", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "lesson_reactions", "users"
  add_foreign_key "progresses", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "votes", "users"
end
