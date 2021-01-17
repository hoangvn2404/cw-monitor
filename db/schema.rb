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

ActiveRecord::Schema.define(version: 2021_01_12_163008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "warrants", force: :cascade do |t|
    t.string "link"
    t.string "stock"
    t.string "issuer"
    t.string "code"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.integer "conversion"
    t.integer "current_warrent_price"
    t.integer "basic_stock_price"
    t.integer "current_stock_price"
    t.integer "percent_need_to_increase"
    t.integer "percent_expired_profile"
    t.integer "percent_premium"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
