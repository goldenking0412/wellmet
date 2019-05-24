# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170822130923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.integer  "question_id",                 null: false
    t.text     "text",                        null: false
    t.boolean  "appreciated", default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "read",        default: false, null: false
    t.boolean  "deactivate",  default: false, null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "color",      default: "#ffffff"
    t.string   "image"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "deactivate", default: false,     null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree

  create_table "hails", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "to_user_id"
    t.string   "message"
    t.boolean  "accepted"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "read",       default: false, null: false
    t.boolean  "deactivate", default: false, null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "category_id",                 null: false
    t.string   "name",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "deactivate",  default: false, null: false
  end

  add_index "interests", ["category_id"], name: "index_interests_on_category_id", using: :btree

  create_table "logincms", force: :cascade do |t|
    t.text     "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "to_user_id"
    t.string   "text"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "read",       default: false, null: false
    t.boolean  "deactivate", default: false, null: false
  end

  add_index "messages", ["to_user_id"], name: "index_messages_on_to_user_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",                       null: false
    t.text     "body",                        null: false
    t.string   "slug",                        null: false
    t.string   "description"
    t.boolean  "deactivate",  default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.text     "text",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "deactivate", default: false, null: false
  end

  add_index "questions", ["latitude"], name: "index_questions_on_latitude", using: :btree
  add_index "questions", ["longitude"], name: "index_questions_on_longitude", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "user_blocks", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "blocked_user_id",                 null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "deactivate",      default: false, null: false
  end

  add_index "user_blocks", ["user_id", "blocked_user_id"], name: "index_user_blocks_on_user_id_and_blocked_user_id", unique: true, using: :btree

  create_table "user_interest_shares", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "interest_id",                 null: false
    t.integer  "to_user_id",                  null: false
    t.boolean  "deactivate",  default: false, null: false
  end

  create_table "user_interests", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.integer  "interest_id",                 null: false
    t.text     "comment"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "like",        default: true,  null: false
    t.boolean  "deactivate",  default: false, null: false
  end

  add_index "user_interests", ["user_id", "interest_id"], name: "index_user_interests_on_user_id_and_interest_id", unique: true, using: :btree
  add_index "user_interests", ["user_id"], name: "index_user_interests_on_user_id", using: :btree

  create_table "user_settings", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "radius"
    t.integer  "common_interests_count"
    t.string   "gender"
    t.text     "ages"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "allow_to_locate_me",     default: true
    t.string   "city_visibility",        default: "public"
    t.boolean  "sound_notification",     default: true
    t.boolean  "question_notification",  default: true
    t.boolean  "hail_notification",      default: true
    t.boolean  "chat_notification",      default: true
    t.boolean  "deactivate",             default: false,    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     default: ""
    t.string   "encrypted_password",        default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "location"
    t.string   "bio"
    t.datetime "date_of_birth",             default: '2020-01-01 00:00:00', null: false
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "geolocation_updated_at"
    t.integer  "last_chatted_user_id"
    t.datetime "questions_last_checked_at"
    t.boolean  "deactivate",                default: false,                 null: false
    t.string   "provider"
    t.string   "uid"
    t.boolean  "admin",                     default: false,                 null: false
    t.boolean  "policy",                    default: false
  end

  add_index "users", ["geolocation_updated_at"], name: "index_users_on_geolocation_updated_at", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
