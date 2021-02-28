# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_16_141649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_prices", force: :cascade do |t|
    t.date "date"
    t.integer "warrant_id"
    t.integer "current_warrant_price"
    t.integer "current_stock_price"
    t.integer "volumn"
    t.float "percent_need_to_increase"
    t.float "percent_expired_profit"
    t.float "percent_premium"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["warrant_id"], name: "index_daily_prices_on_warrant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "watch_list_cw_ids", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warrants", force: :cascade do |t|
    t.string "link"
    t.string "stock"
    t.string "issuer"
    t.string "code"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.float "conversion"
    t.integer "current_warrant_price"
    t.integer "basic_stock_price"
    t.integer "current_stock_price"
    t.float "percent_need_to_increase"
    t.float "percent_expired_profit"
    t.float "percent_premium"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tham_chieu"
  end

end
