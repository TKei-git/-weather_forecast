class CreateOwmDailyForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :owm_daily_forecasts do |t|

      t.date    :dt
      t.time    :sunrise
      t.time    :sunset
      t.time    :moonrise
      t.time    :moonset
      t.float   :moon_phase
      t.float   :temp_day
      t.float   :temp_min
      t.float   :temp_max
      t.float   :temp_night
      t.float   :temp_eve
      t.float   :temp_morn
      t.float   :feels_like_day
      t.float   :feels_like_night
      t.float   :feels_like_eve
      t.float   :feels_like_morn
      t.integer :pressure
      t.integer :humidity
      t.float   :dew_point
      t.float   :wind_speed
      t.integer :wind_deg
      t.float   :wind_gust
      t.integer :weather_id
      t.string  :weather_main
      t.string  :weather_description
      t.string  :weather_icon
      t.integer :clouds
      t.float   :pop
      t.float   :rain
      t.float   :uvi
      t.timestamps
    end
  end
end
