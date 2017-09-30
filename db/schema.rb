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

ActiveRecord::Schema.define(version: 20170930133306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bosses", force: :cascade do |t|
    t.integer  "bot_id"
    t.string   "name"
    t.integer  "max_hp"
    t.integer  "current_hp"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "current_shield", default: 0
    t.string   "avatar"
    t.string   "token"
    t.integer  "max_shield"
    t.index ["bot_id"], name: "index_bosses_on_bot_id", using: :btree
  end

  create_table "bots", force: :cascade do |t|
    t.string   "channel"
    t.integer  "user_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "token"
    t.integer  "boss_max_hp",              default: 5000
    t.integer  "boss_min_hp",              default: 1000
    t.integer  "boss_hp_step",             default: 200
    t.integer  "sub_prime_modifier",       default: 500
    t.integer  "sub_five_modifier",        default: 500
    t.integer  "sub_ten_modifier",         default: 1000
    t.integer  "sub_twenty_five_modifier", default: 3000
    t.integer  "bits_modifier",            default: 1
    t.index ["user_id"], name: "index_bots_on_user_id", using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.string   "log_type"
    t.string   "username"
    t.string   "sub_plan"
    t.integer  "bits_amount"
    t.string   "message"
    t.integer  "amount"
    t.string   "boss_name"
    t.integer  "bot_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "month"
    t.index ["bot_id"], name: "index_logs_on_bot_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.boolean  "admin",                  default: false
    t.string   "time_zone"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bosses", "bots"
  add_foreign_key "bots", "users"
  add_foreign_key "logs", "bots"
end
