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

ActiveRecord::Schema.define(version: 20150125213700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "shippable"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id",             null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_w"
    t.integer  "crop_h"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer  "article_id_1"
    t.integer  "article_id_2"
    t.integer  "user_1"
    t.integer  "user_2"
    t.string   "user_1_accept"
    t.string   "user_2_accept"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "exchanges", ["article_id_1"], name: "index_exchanges_on_article_id_1", using: :btree
  add_index "exchanges", ["article_id_2"], name: "index_exchanges_on_article_id_2", using: :btree
  add_index "exchanges", ["user_1"], name: "index_exchanges_on_user_1", using: :btree
  add_index "exchanges", ["user_1_accept"], name: "index_exchanges_on_user_1_accept", using: :btree
  add_index "exchanges", ["user_2"], name: "index_exchanges_on_user_2", using: :btree
  add_index "exchanges", ["user_2_accept"], name: "index_exchanges_on_user_2_accept", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "favorite_id"
    t.integer  "user_id"
    t.boolean  "like"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "matches", ["favorite_id"], name: "index_matches_on_favorite_id", using: :btree
  add_index "matches", ["user_id"], name: "index_matches_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "text"
    t.integer  "sender"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "location"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_w"
    t.integer  "crop_h"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
