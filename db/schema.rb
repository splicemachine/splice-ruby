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

ActiveRecord::Schema.define(version: 20161026132222) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id",   limit: 10
    t.string   "addressable_type", limit: 255
    t.string   "street_name",      limit: 255
    t.string   "street_number",    limit: 255
    t.string   "city",             limit: 255
    t.string   "country",          limit: 255
    t.datetime "created_at",       limit: 29,  null: false
    t.datetime "updated_at",       limit: 29,  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",  limit: 29,               null: false
    t.datetime "updated_at",  limit: 29,               null: false
    t.string   "description", limit: 255, default: ""
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",      limit: 10
    t.string   "profile_name", limit: 255
    t.integer  "views",        limit: 10,  default: 0
    t.datetime "created_at",   limit: 29,              null: false
    t.datetime "updated_at",   limit: 29,              null: false
  end

  create_table "profiles_tags", id: false, force: :cascade do |t|
    t.integer "profile_id", limit: 10, null: false
    t.integer "tag_id",     limit: 10, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "user_id",     limit: 10
    t.integer  "number",      limit: 10,                                 default: 0
    t.string   "header",      limit: 255,                                default: ""
    t.text     "description", limit: 2147483647
    t.float    "gravity",     limit: 23,                                 default: 9.807
    t.decimal  "velocity",                       precision: 5, scale: 2, default: 0.0
    t.boolean  "enabled",     limit: 1,                                  default: true
    t.binary   "image",       limit: 2147483647
    t.date     "birthday",    limit: 10,                                 default: '2016-11-15'
    t.time     "birthtime",   limit: 8,                                  default: '2000-01-01 14:20:03'
    t.datetime "deadline",    limit: 29,                                 default: '2016-11-15 14:20:03'
    t.datetime "created_at",  limit: 29,                                                                 null: false
    t.datetime "updated_at",  limit: 29,                                                                 null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at", limit: 29,  null: false
    t.datetime "updated_at", limit: 29,  null: false
  end

  create_table "tags_users", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 10, null: false
    t.integer "tag_id",  limit: 10, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "company_id", limit: 10
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at", limit: 29,              null: false
    t.datetime "updated_at", limit: 29,              null: false
    t.integer  "credit",     limit: 10,  default: 0
  end

end
