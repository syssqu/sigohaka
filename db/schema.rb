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

ActiveRecord::Schema.define(version: 20140605054113) do

  create_table "attendances", force: true do |t|
    t.date     "attendance_date"
    t.string   "year",            limit: 4
    t.string   "month",           limit: 2
    t.string   "day",             limit: 2
    t.string   "wday",            limit: 1
    t.string   "pattern",         limit: 1
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "byouketu"
    t.boolean  "kekkin"
    t.boolean  "hankekkin"
    t.boolean  "titoku"
    t.boolean  "soutai"
    t.boolean  "gaisyutu"
    t.boolean  "tokkyuu"
    t.boolean  "furikyuu"
    t.boolean  "yuukyuu"
    t.boolean  "syuttyou"
    t.integer  "over_time"
    t.integer  "holiday_time"
    t.integer  "midnight_time"
    t.integer  "break_time"
    t.integer  "kouzyo_time"
    t.integer  "work_time"
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["user_id", "year", "month", "day"], name: "index_attendances_on_user_id_and_year_and_month_and_day"

  create_table "kinmu_patterns", force: true do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "break_time"
    t.integer  "work_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportation_expresses", force: true do |t|
    t.integer  "user_id"
    t.date     "koutu_date"
    t.string   "destination"
    t.string   "route"
    t.string   "transport"
    t.integer  "money"
    t.string   "note"
    t.integer  "sum"
    t.string   "year",        limit: 4
    t.string   "month",       limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "family_name",            limit: 20
    t.string   "first_name",             limit: 20
    t.string   "kana_family_name",       limit: 40
    t.string   "kana_first_name",        limit: 40
    t.integer  "section_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
