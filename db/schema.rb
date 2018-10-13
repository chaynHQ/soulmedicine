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

ActiveRecord::Schema.define(version: 2018_10_13_214003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_translations", force: :cascade do |t|
    t.integer "course_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.string "notes"
    t.index ["course_id"], name: "index_course_translations_on_course_id"
    t.index ["locale"], name: "index_course_translations_on_locale"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "sequential_id"
    t.boolean "active"
    t.boolean "approved"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["owner_id"], name: "index_courses_on_owner_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lesson_translations", force: :cascade do |t|
    t.integer "lesson_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content"
    t.string "notes"
    t.index ["lesson_id"], name: "index_lesson_translations_on_lesson_id"
    t.index ["locale"], name: "index_lesson_translations_on_locale"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "subject_id"
    t.integer "sequential_id"
    t.integer "status"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_lessons_on_subject_id"
  end

  create_table "subject_translations", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.string "notes"
    t.index ["locale"], name: "index_subject_translations_on_locale"
    t.index ["subject_id"], name: "index_subject_translations_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.bigint "course_id"
    t.integer "sequential_id"
    t.integer "status"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_subjects_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "courses", "users", column: "owner_id"
  add_foreign_key "lessons", "subjects"
  add_foreign_key "subjects", "courses"
end
