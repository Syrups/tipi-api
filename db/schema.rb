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

ActiveRecord::Schema.define(version: 20150217161556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_audios", force: :cascade do |t|
    t.string   "file"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "page_id"
    t.integer  "comment_id"
    t.integer  "user_id"
  end

  create_table "api_comments", force: :cascade do |t|
    t.integer  "page_id"
    t.integer  "audio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "api_media", force: :cascade do |t|
    t.string   "file"
    t.integer  "page_id"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_pages", force: :cascade do |t|
    t.float    "duration"
    t.integer  "position"
    t.boolean  "has_only_sound"
    t.integer  "story_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "api_receptions", force: :cascade do |t|
    t.datetime "received_at"
    t.boolean  "acknowledged"
    t.integer  "story_id"
    t.integer  "receiver_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "api_stories", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.string   "title"
    t.integer  "page_count"
    t.integer  "user_id"
    t.datetime "updated_at",                     null: false
    t.boolean  "published",  default: false
    t.string   "story_type", default: "private"
    t.boolean  "candidate",  default: false
  end

  create_table "api_subscribtions", force: :cascade do |t|
    t.datetime "invited_at"
    t.datetime "subscribed_at"
    t.boolean  "active"
    t.integer  "user_id"
    t.integer  "subscriber_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "api_users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "salt"
    t.string   "token"
    t.datetime "last_request"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "account_type", default: "basic"
    t.integer  "audio_id"
  end

end
