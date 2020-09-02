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

ActiveRecord::Schema.define(version: 2020_09_02_194906) do

  create_table "behaviors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "its", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.text "situation"
    t.text "behavior"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_its_on_user_id"
  end

  create_table "lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.text "answer"
    t.boolean "done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "event"
    t.text "respect"
    t.text "disdain"
    t.text "boss"
    t.text "guidance"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "macs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.text "measurable"
    t.text "actionable"
    t.text "competent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_macs_on_user_id"
  end

  create_table "situations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "behavior_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["behavior_id"], name: "index_situations_on_behavior_id"
    t.index ["user_id"], name: "index_situations_on_user_id"
  end

  create_table "steps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.date "step_day"
    t.integer "step_time"
    t.text "step_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "goal"
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.boolean "done"
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority"
    t.index ["user_id", "created_at"], name: "index_tasks_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "its", "users"
  add_foreign_key "lists", "users"
  add_foreign_key "macs", "users"
  add_foreign_key "situations", "behaviors"
  add_foreign_key "situations", "users"
  add_foreign_key "steps", "users"
  add_foreign_key "tasks", "users"
end
