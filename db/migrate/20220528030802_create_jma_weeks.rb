class CreateJmaWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :jma_weeks do |t|

      t.date    :date
      t.string  :area_code
      t.string  :weather
      t.integer :chance_of_rain
      t.string  :reliability
      t.float   :temperature_max
      t.float   :temperature_min

      t.timestamps
    end
  end
end
