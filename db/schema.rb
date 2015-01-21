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

ActiveRecord::Schema.define(version: 20150121052811) do

  create_table "attendance_others", force: true do |t|
    t.string   "summary"
    t.time     "start_time"
    t.time     "end_time"
    t.decimal  "over_time",               precision: 4, scale: 2, default: 0.0
    t.decimal  "holiday_time",            precision: 4, scale: 2, default: 0.0
    t.decimal  "midnight_time",           precision: 4, scale: 2, default: 0.0
    t.decimal  "break_time",              precision: 4, scale: 2, default: 0.0
    t.decimal  "kouzyo_time",             precision: 4, scale: 2, default: 0.0
    t.decimal  "work_time",               precision: 4, scale: 2, default: 0.0
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "year",          limit: 4
    t.string   "month",         limit: 2
  end

  create_table "attendances", force: true do |t|
    t.date     "attendance_date"
    t.string   "year",            limit: 4
    t.string   "month",           limit: 2
    t.string   "day",             limit: 2
    t.string   "wday",            limit: 1
    t.string   "pattern",         limit: 1
    t.string   "start_time",      limit: 5
    t.string   "end_time",        limit: 5
    t.boolean  "byouketu",                                          default: false
    t.boolean  "kekkin",                                            default: false
    t.boolean  "hankekkin",                                         default: false
    t.boolean  "tikoku",                                            default: false
    t.boolean  "soutai",                                            default: false
    t.boolean  "gaisyutu",                                          default: false
    t.boolean  "tokkyuu",                                           default: false
    t.boolean  "furikyuu",                                          default: false
    t.boolean  "yuukyuu",                                           default: false
    t.boolean  "syuttyou",                                          default: false
    t.decimal  "over_time",                 precision: 4, scale: 2, default: 0.0
    t.decimal  "holiday_time",              precision: 4, scale: 2, default: 0.0
    t.decimal  "midnight_time",             precision: 4, scale: 2, default: 0.0
    t.decimal  "break_time",                precision: 4, scale: 2, default: 0.0
    t.decimal  "kouzyo_time",               precision: 4, scale: 2, default: 0.0
    t.decimal  "work_time",                 precision: 4, scale: 2, default: 0.0
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "holiday",         limit: 1,                         default: "0"
    t.boolean  "hankyuu",                                           default: false
    t.boolean  "self_approved",                                     default: false
    t.boolean  "boss_approved",                                     default: false
    t.boolean  "freezed",                                           default: false
  end

  add_index "attendances", ["user_id", "year", "month", "day"], name: "index_attendances_on_user_id_and_year_and_month_and_day"

  create_table "business_reports", force: true do |t|
    t.integer  "user_id"
    t.text     "naiyou"
    t.text     "jisseki"
    t.string   "tool"
    t.string   "self_purpose"
    t.string   "self_value"
    t.string   "self_reason"
    t.text     "user_situation"
    t.text     "request"
    t.string   "develop_purpose"
    t.text     "develop_jisseki"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reflection"
    t.boolean  "freezed"
    t.boolean  "self_approved"
    t.boolean  "boss_approved"
    t.string   "year",            limit: 4
    t.string   "month",           limit: 2
  end

  create_table "commutes", force: true do |t|
    t.integer  "user_id"
    t.string   "year",          limit: 4
    t.string   "month",         limit: 2
    t.string   "reason"
    t.string   "reason_text"
    t.string   "transport"
    t.string   "segment1"
    t.string   "segment2"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "freezed"
    t.boolean  "self_approved"
    t.boolean  "boss_approved"
  end

  create_table "housing_allowances", force: true do |t|
    t.integer  "user_id"
    t.string   "year",               limit: 4
    t.string   "month",              limit: 2
    t.string   "reason"
    t.string   "reason_text"
    t.string   "housing_style"
    t.string   "housing_style_text"
    t.date     "agree_date_s"
    t.date     "agree_date_e"
    t.string   "spouse"
    t.string   "spouse_name"
    t.string   "spouse_other"
    t.string   "support"
    t.string   "support_name1"
    t.string   "support_name2"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "freezed"
    t.boolean  "self_approved"
    t.boolean  "boss_approved"
  end

  create_table "katagakis", force: true do |t|
    t.string   "name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kinmu_patterns", force: true do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.decimal  "break_time",           precision: 4, scale: 2, default: 0.0
    t.decimal  "work_time",            precision: 4, scale: 2, default: 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       limit: 2
  end

  create_table "licenses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "years"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "summary"
    t.text     "description"
    t.string   "os"
    t.string   "language"
    t.string   "database"
    t.string   "dep_size"
    t.string   "role"
    t.string   "experience"
    t.text     "remarks"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.integer  "term"
  end

  create_table "qualification_allowances", force: true do |t|
    t.integer  "user_id"
    t.string   "number"
    t.string   "item"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "get_date"
    t.string   "registration_no_alphabet"
    t.integer  "registration_no_year"
    t.integer  "registration_no_month"
    t.integer  "registration_no_individual"
    t.string   "year",                       limit: 4
    t.string   "month",                      limit: 2
  end

  create_table "reasons", force: true do |t|
    t.integer  "user_id"
    t.string   "reason"
    t.string   "reason_text"
    t.string   "year",          limit: 4
    t.string   "month",         limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "freezed"
    t.boolean  "self_approved"
    t.boolean  "boss_approved"
  end

  create_table "sections", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "summary_attendances", force: true do |t|
    t.integer  "user_id"
    t.string   "year",         limit: 4
    t.string   "month",        limit: 2
    t.integer  "previous_m"
    t.integer  "present_m"
    t.integer  "vacation"
    t.integer  "half_holiday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
  end

  create_table "time_lines", force: true do |t|
    t.string   "title"
    t.text     "contents"
    t.integer  "user_id"
    t.integer  "create_user_id"
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
    t.string   "year",          limit: 4
    t.string   "month",         limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "freezed"
    t.string   "day"
    t.boolean  "self_approved"
    t.boolean  "boss_approved"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                                     default: "", null: false
    t.string   "encrypted_password",                                        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                             default: 0,  null: false
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
    t.string   "gender",                 limit: 10
    t.date     "birth_date"
    t.string   "employee_no",            limit: 6
    t.integer  "age"
    t.decimal  "experience",                        precision: 5, scale: 1
    t.string   "postal_code",            limit: 8
    t.string   "prefecture"
    t.string   "city",                   limit: 80
    t.string   "house_number",           limit: 80
    t.string   "building",               limit: 80
    t.string   "phone",                  limit: 13
    t.string   "gakureki"
    t.text     "remarks"
    t.string   "role"
    t.string   "station"
    t.string   "imprint_id"
    t.date     "employee_date"
    t.integer  "katagaki_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vacation_requests", force: true do |t|
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "term"
    t.string   "category"
    t.string   "reason"
    t.string   "note"
    t.string   "year"
    t.string   "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vacation_requests", ["user_id", "year", "month"], name: "index_vacation_requests_on_user_id_and_year_and_month"

end
