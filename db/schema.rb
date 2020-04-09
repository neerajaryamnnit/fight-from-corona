# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_09_150333) do

  create_table "app_configs", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer "creator_id"
    t.integer "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer "creator_id"
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "daily_cases", force: :cascade do |t|
    t.integer "total"
    t.integer "decease"
    t.integer "recover"
    t.integer "active"
    t.integer "suspected"
    t.datetime "last_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "issue_activities", force: :cascade do |t|
    t.string "name"
    t.integer "creator_id"
    t.integer "issue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_issue_activities_on_creator_id"
    t.index ["issue_id"], name: "index_issue_activities_on_issue_id"
  end

  create_table "issue_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "issue_category_translations", force: :cascade do |t|
    t.string "name"
    t.string "language"
    t.integer "issue_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_category_id"], name: "index_issue_category_translations_on_issue_category_id"
  end

  create_table "issue_sub_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "issue_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_category_id"], name: "index_issue_sub_categories_on_issue_category_id"
  end

  create_table "issue_sub_category_translations", force: :cascade do |t|
    t.string "name"
    t.string "language"
    t.integer "issue_sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_sub_category_id"], name: "index_issue_sub_category_translations_on_issue_sub_category_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "lat"
    t.float "long"
    t.integer "issue_category_id"
    t.integer "issue_sub_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "address"
    t.datetime "reported_at"
    t.datetime "resolved_at"
    t.integer "resolved_by_id"
    t.string "aasm_state"
    t.integer "pincode"
    t.string "city"
    t.index ["issue_category_id"], name: "index_issues_on_issue_category_id"
    t.index ["issue_sub_category_id"], name: "index_issues_on_issue_sub_category_id"
    t.index ["resolved_by_id"], name: "index_issues_on_resolved_by_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "mobile"
    t.float "lat"
    t.float "long"
    t.string "password"
    t.string "otp"
    t.datetime "otp_verified_at"
    t.string "temp_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "otp_created_at"
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "issue_activities", "issues"
  add_foreign_key "issue_activities", "users", column: "creator_id"
  add_foreign_key "issue_category_translations", "issue_categories"
  add_foreign_key "issue_sub_category_translations", "issue_sub_categories"
  add_foreign_key "issues", "issue_categories"
  add_foreign_key "issues", "issue_sub_categories"
  add_foreign_key "issues", "users"
  add_foreign_key "issues", "users", column: "resolved_by_id"
end
