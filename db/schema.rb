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

ActiveRecord::Schema.define(version: 20170911170410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bosses", force: :cascade do |t|
    t.integer  "bot_id"
    t.string   "name"
    t.integer  "max_hp"
    t.integer  "current_hp"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "shield",     default: 0
    t.string   "avatar"
    t.datetime "saved_at"
    t.index ["bot_id"], name: "index_bosses_on_bot_id", using: :btree
  end

  create_table "bots", force: :cascade do |t|
    t.string   "channel"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "running",      default: false
    t.string   "token"
    t.integer  "max_boss_hp"
    t.integer  "min_boss_hp"
    t.integer  "boss_hp_step"
    t.index ["user_id"], name: "index_bots_on_user_id", using: :btree
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.boolean  "admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bosses", "bots"
  add_foreign_key "bots", "users"
end
