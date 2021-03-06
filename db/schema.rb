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

ActiveRecord::Schema.define(version: 20150408214701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "item_id"
    t.text     "given_url"
    t.text     "given_title"
    t.integer  "favorite"
    t.integer  "status"
    t.integer  "is_article"
    t.integer  "word_count"
    t.integer  "fetch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "push_id"
    t.integer  "time_added_pocket"
    t.integer  "time_updated_pocket"
    t.integer  "time_read"
    t.integer  "time_favorited"
    t.integer  "user_id"
  end

  add_index "articles", ["created_at"], name: "index_articles_on_created_at", using: :btree
  add_index "articles", ["item_id", "user_id"], name: "article_pk", unique: true, using: :btree

  create_table "articles_tags", force: :cascade do |t|
    t.integer "article_id"
    t.integer "tag_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "fetches", force: :cascade do |t|
    t.boolean  "full_fetch"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished"
  end

  create_table "pushes", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_tag_name"
    t.string   "comparator"
    t.integer  "article_length"
    t.string   "destination_tag_name"
  end

  add_index "pushes", ["user_id", "source_tag_name", "destination_tag_name", "comparator", "article_length"], name: "pushes_pk", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.boolean  "admin",          default: false
    t.string   "uid"
    t.string   "pocket_token"
    t.integer  "wpm",            default: 200
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
