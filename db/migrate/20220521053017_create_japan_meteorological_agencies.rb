class CreateJapanMeteorologicalAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :japan_meteorological_agencies do |t|
      t.time :date
      t.string :weather
      t.string :wind
      t.string :wave
      t.float :temperature_min
      t.float :temperature_max
      t.integer :chance_of_rain_06
      t.integer :chance_of_rain_12
      t.integer :chance_of_rain_18
      t.integer :chance_of_rain_24
      t.string :provider
      t.string :area
      t.string :prefecture
      t.string :district

      t.timestamps
    end
  end
end
