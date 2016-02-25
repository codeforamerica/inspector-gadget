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

ActiveRecord::Schema.define(version: 20160225022935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "addresses", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "city"
    t.string   "zip"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "inspection_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "inspector_id"
    t.integer  "inspection_id"
    t.datetime "scheduled_for"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "inspection_types", force: :cascade do |t|
    t.string "inspection_category"
    t.string "inspection_name"
  end

  create_table "inspections", force: :cascade do |t|
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.datetime "requested_for_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "permit_number"
    t.string   "property_type"
    t.string   "requested_for_time"
    t.text     "notes"
    t.integer  "inspection_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
