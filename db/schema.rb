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

ActiveRecord::Schema[7.0].define(version: 2022_05_21_053017) do
  create_table "japan_meteorological_agencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.time "date"
    t.string "weather"
    t.string "wind"
    t.string "wave"
    t.float "temperature_min"
    t.float "temperature_max"
    t.integer "chance_of_rain_06"
    t.integer "chance_of_rain_12"
    t.integer "chance_of_rain_18"
    t.integer "chance_of_rain_24"
    t.string "provider"
    t.string "area"
    t.string "prefecture"
    t.string "district"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end