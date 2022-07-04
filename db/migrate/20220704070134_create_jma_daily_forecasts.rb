class CreateJmaDailyForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :jma_daily_forecasts do |t|

      t.date    :date
      t.string  :weather_code
      t.string  :weather
      t.float   :chance_of_rain
      t.string  :reliability
      t.float   :temperature_min
      t.float   :temperature_min_upper
      t.float   :temperature_min_lower
      t.float   :temperature_max
      t.float   :temperature_max_upper
      t.float   :temperature_max_lower
      t.timestamps
    end
  end
end
