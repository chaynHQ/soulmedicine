# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_24_204505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "course_slug", null: false
    t.boolean "active", default: false, null: false
    t.string "main_language", null: false
    t.string "other_languages", default: [], null: false, array: true
    t.string "delivery_method", null: false
    t.string "days_utc", default: [], null: false, array: true
    t.integer "hours_utc", default: [], null: false, array: true
    t.string "lessons_delivered", default: [], array: true
    t.datetime "last_delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_subscriptions_on_active"
    t.index ["user_id", "course_slug"], name: "index_subscriptions_on_user_id_and_course_slug", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_name", null: false
    t.string "firebase_id", null: false
    t.string "email", null: false
    t.boolean "email_verified", default: false
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firebase_id"], name: "index_users_on_firebase_id", unique: true
  end

  add_foreign_key "subscriptions", "users"
end
