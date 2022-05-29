class CreateJmaWeatherCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :jma_weather_codes do |t|

      t.string  :weather_code
      t.string  :day_image
      t.string  :night_image
      t.string  :about_code
      t.string  :weather
      t.string  :weatehr_english

      t.timestamps
    end
  end
end
