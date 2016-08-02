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

ActiveRecord::Schema.define(version: 20160802232427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "pg_stat_statements"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string    "city"
    t.string    "zip"
    t.datetime  "created_at",                                                             null: false
    t.datetime  "updated_at",                                                             null: false
    t.integer   "inspection_id"
    t.string    "state"
    t.geography "geo_location",  limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "street_number"
    t.string    "route"
  end

  add_index "addresses", ["inspection_id"], name: "index_addresses_on_inspection_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.integer  "inspector_profile_id"
    t.integer  "inspection_type_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "inspection_types", force: :cascade do |t|
    t.string "inspection_category"
    t.string "inspection_name"
    t.string "inspection_supercategory"
    t.text   "comments"
    t.string "inspection_category_name"
    t.string "inspection_supercategory_name"
  end

  create_table "inspections", force: :cascade do |t|
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.datetime "requested_for_date"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "permit_number"
    t.string   "property_type"
    t.string   "requested_for_time"
    t.text     "address_notes"
    t.integer  "inspection_type_id"
    t.string   "inspection_notes"
    t.boolean  "contact_phone_can_text", default: false
  end

  create_table "inspector_profiles", force: :cascade do |t|
    t.integer   "inspector_id"
    t.string    "inspector_type"
    t.text      "inspection_assignments",                                                                  default: [],              array: true
    t.datetime  "created_at",                                                                                           null: false
    t.datetime  "updated_at",                                                                                           null: false
    t.geography "inspection_region",      limit: {:srid=>4326, :type=>"multi_polygon", :geographic=>true}
  end

  add_index "inspector_profiles", ["inspector_id"], name: "index_inspector_profiles_on_inspector_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
