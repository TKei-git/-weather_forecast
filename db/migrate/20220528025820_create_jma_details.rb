class CreateJmaDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :jma_details do |t|
      
      t.date    :date
      t.string  :area_code
      t.string  :weather
      t.string  :wind
      t.string  :wave
      t.integer :chance_of_rain_06
      t.integer :chance_of_rain_12
      t.integer :chance_of_rain_18
      t.integer :chance_of_rain_24
      t.float   :temperature_max
      t.float   :temperature_min
      
      t.timestamps
    end
  end
end
