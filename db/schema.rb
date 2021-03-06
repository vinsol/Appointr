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

ActiveRecord::Schema.define(version: 20141226092735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: true do |t|
    t.integer "service_id"
    t.integer "staff_id"
  end

  create_table "application_images", force: true do |t|
    t.string   "type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "appointments", force: true do |t|
    t.integer  "staff_id"
    t.integer  "service_id"
    t.integer  "customer_id"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.text     "remarks"
    t.string   "state"
    t.integer  "reminder_job_id"
  end

  create_table "availabilities", force: true do |t|
    t.integer  "staff_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "days",       default: [0, 1, 2, 3, 4, 5, 6], array: true
  end

  create_table "availability_services", force: true do |t|
    t.integer  "service_id"
    t.integer  "availability_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "services", force: true do |t|
    t.string  "name"
    t.integer "duration"
    t.boolean "enabled",  default: true
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "designation"
    t.string   "type"
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",                default: true
    t.integer  "reminder_time_lapse",    default: 240
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
