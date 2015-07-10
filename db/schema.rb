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

ActiveRecord::Schema.define(version: 20150709203600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "package_docs", force: :cascade do |t|
    t.integer  "package_id",   null: false
    t.string   "name",         null: false
    t.string   "sha",          null: false
    t.datetime "generated_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "package_docs", ["package_id", "name", "sha"], name: "index_package_docs_on_package_id_and_name_and_sha", unique: true, using: :btree
  add_index "package_docs", ["package_id", "name"], name: "index_package_docs_on_package_id_and_name", unique: true, using: :btree
  add_index "package_docs", ["package_id"], name: "index_package_docs_on_package_id", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "hosting",    null: false
    t.string   "owner",      null: false
    t.string   "repo",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "packages", ["hosting", "owner", "repo"], name: "index_packages_on_hosting_and_owner_and_repo", unique: true, using: :btree

  add_foreign_key "package_docs", "packages"
end
