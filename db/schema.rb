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

ActiveRecord::Schema[7.0].define(version: 2022_07_04_083045) do
  create_table "japan_meteorological_agencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
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
    t.integer "chance_of_rain"
  end

  create_table "jma_daily_detailed_forecasts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.string "weather_code"
    t.string "weather"
    t.string "detailed_weather"
    t.string "wind"
    t.string "wave"
    t.float "chance_of_rain_06"
    t.float "chance_of_rain_12"
    t.float "chance_of_rain_18"
    t.float "chance_of_rain_24"
    t.float "temperature_min"
    t.float "temperature_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jma_daily_forecasts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.string "weather_code"
    t.string "weather"
    t.float "chance_of_rain"
    t.string "reliability"
    t.float "temperature_min"
    t.float "temperature_min_upper"
    t.float "temperature_min_lower"
    t.float "temperature_max"
    t.float "temperature_max_upper"
    t.float "temperature_max_lower"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jma_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.string "area_code"
    t.string "weather"
    t.string "wind"
    t.string "wave"
    t.integer "chance_of_rain_06"
    t.integer "chance_of_rain_12"
    t.integer "chance_of_rain_18"
    t.integer "chance_of_rain_24"
    t.float "temperature_max"
    t.float "temperature_min"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jma_weather_codes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "weather_code"
    t.string "day_image"
    t.string "night_image"
    t.string "about_code"
    t.string "weather"
    t.string "weatehr_english"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jma_weeks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.string "area_code"
    t.string "weather"
    t.integer "chance_of_rain"
    t.string "reliability"
    t.float "temperature_max"
    t.float "temperature_min"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "om_daily_forecasts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "time"
    t.time "sunrise"
    t.time "sunset"
    t.float "weathercode"
    t.float "temperature_2m_max"
    t.float "temperature_2m_min"
    t.float "apparent_temperature_max"
    t.float "apparent_temperature_min"
    t.float "precipitation_sum"
    t.float "rain_sum"
    t.float "showers_sum"
    t.float "snowfall_sum"
    t.float "precipitation_hours"
    t.float "windspeed_10m_max"
    t.float "windgusts_10m_max"
    t.float "winddirection_10m_dominant"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owm_daily_forecasts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "dt"
    t.time "sunrise"
    t.time "sunset"
    t.time "moonrise"
    t.time "moonset"
    t.float "moon_phase"
    t.float "temp_day"
    t.float "temp_min"
    t.float "temp_max"
    t.float "temp_night"
    t.float "temp_eve"
    t.float "temp_morn"
    t.float "feels_like_day"
    t.float "feels_like_night"
    t.float "feels_like_eve"
    t.float "feels_like_morn"
    t.integer "pressure"
    t.integer "humidity"
    t.float "dew_point"
    t.float "wind_speed"
    t.integer "wind_deg"
    t.float "wind_gust"
    t.integer "weather_id"
    t.string "weather_main"
    t.string "weather_description"
    t.string "weather_icon"
    t.integer "clouds"
    t.float "pop"
    t.float "rain"
    t.float "uvi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
