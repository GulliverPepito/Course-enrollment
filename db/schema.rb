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

ActiveRecord::Schema.define(version: 20170801040937) do

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "github_nickname"
    t.string "github_name"
    t.string "github_email"
    t.string "github_image_url"
    t.string "github_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_name"
    t.string "google_email"
    t.string "google_image"
    t.string "google_token"
    t.string "manual_first_name"
    t.string "manual_last_name"
    t.boolean "repo_order"
    t.boolean "repo_ready"
    t.string "repo_url"
    t.string "repo_name"
  end

end
