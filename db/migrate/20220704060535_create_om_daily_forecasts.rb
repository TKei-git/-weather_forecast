class CreateOmDailyForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :om_daily_forecasts do |t|

      t.date       :time
      t.datetime   :sunrise
      t.datetime   :sunset
      t.float      :weathercode
      t.float      :temperature_2m_max
      t.float      :temperature_2m_min
      t.float      :apparent_temperature_max
      t.float      :apparent_temperature_min
      t.float      :precipitation_sum
      t.float      :rain_sum
      t.float      :showers_sum
      t.float      :snowfall_sum
      t.float      :precipitation_hours
      t.float      :windspeed_10m_max
      t.float      :windgusts_10m_max
      t.float      :winddirection_10m_dominant
      t.timestamps
    end
  end
end
