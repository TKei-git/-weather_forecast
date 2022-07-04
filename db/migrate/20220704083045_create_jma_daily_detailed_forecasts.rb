class CreateJmaDailyDetailedForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :jma_daily_detailed_forecasts do |t|

      t.date    :date
      t.string  :weather_code
      t.string  :weather
      t.string  :detailed_weather
      t.string  :wind
      t.string  :wave
      t.float   :chance_of_rain_06
      t.float   :chance_of_rain_12
      t.float   :chance_of_rain_18
      t.float   :chance_of_rain_24
      t.float   :temperature_min
      t.float   :temperature_max
      t.timestamps
    end
  end
end
