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

ActiveRecord::Schema.define(version: 20150421095540) do

  create_table "applications", force: :cascade do |t|
    t.string   "job_id",     limit: 255
    t.string   "node_id",    limit: 255
    t.string   "resume_id",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "email_templates", force: :cascade do |t|
    t.string   "email_name", limit: 255
    t.text     "email_html", limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "job_title",           limit: 255
    t.text     "job_description",     limit: 65535
    t.string   "required_experience", limit: 255
    t.text     "job_requirement",     limit: 65535
    t.string   "job_type",            limit: 255
    t.string   "address",             limit: 255
    t.integer  "salary",              limit: 4
    t.string   "company_name",        limit: 255
    t.string   "city",                limit: 255
    t.string   "state",               limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "previous_id", limit: 255
    t.string   "user_phone",  limit: 255
    t.string   "job_id",      limit: 255
    t.string   "player",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "phone",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "resumes", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "email",                      limit: 255
    t.string   "city",                       limit: 255
    t.string   "experience_year",            limit: 255
    t.string   "school_name",                limit: 255
    t.string   "company_name",               limit: 255
    t.string   "degree",                     limit: 255
    t.string   "phone_number",               limit: 255
    t.date     "school_start_date"
    t.date     "school_end_date"
    t.date     "work_start_date"
    t.date     "work_end_date"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "position_brief_description", limit: 65535
    t.text     "job_brief_description",      limit: 65535
    t.text     "school_brief_description",   limit: 65535
    t.string   "position_title",             limit: 255
  end

end
