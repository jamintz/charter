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

ActiveRecord::Schema.define(version: 20170502143540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attrs", force: :cascade do |t|
    t.string   "name"
    t.string   "result"
    t.datetime "time"
    t.integer  "library"
    t.float    "exec_time"
    t.string   "connector"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "filepicker_field"
    t.integer  "client_id"
  end

  create_table "bins", force: :cascade do |t|
    t.string   "bin"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.string   "library"
    t.float    "freq"
    t.string   "connector"
    t.string   "week"
    t.string   "month"
    t.integer  "client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "trx_url"
    t.string   "attr_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connectors", force: :cascade do |t|
    t.string   "name"
    t.float    "exec_time"
    t.datetime "time"
    t.string   "library"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "client_id"
  end

  create_table "factors", force: :cascade do |t|
    t.string   "library"
    t.string   "name"
    t.string   "level"
    t.float    "freq"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "connector"
    t.string   "week"
    t.string   "month"
    t.integer  "client_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "library"
    t.datetime "time"
    t.string   "kind"
    t.float    "duration"
    t.string   "ip"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "status"
    t.string   "region"
    t.string   "apikey"
    t.string   "filepicker_field"
    t.integer  "client_id"
  end

end
