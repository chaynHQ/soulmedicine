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

ActiveRecord::Schema.define(version: 2019_10_02_180118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "backups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "key"
    t.jsonb "data"
    t.index ["key"], name: "index_backups_on_key", unique: true
    t.index ["user_id"], name: "index_backups_on_user_id"
  end

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
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "terms_accepted", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["firebase_id"], name: "index_users_on_firebase_id", unique: true
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "course_slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_slug"], name: "index_votes_on_course_slug"
    t.index ["user_id", "course_slug"], name: "index_votes_on_user_id_and_course_slug", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "backups", "users"
  add_foreign_key "storyblok_backups", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "votes", "users"
end
