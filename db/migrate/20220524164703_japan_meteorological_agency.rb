class JapanMeteorologicalAgency < ActiveRecord::Migration[7.0]
  def change
    add_column :japan_meteorological_agencies, :chance_of_rain, :integer
  end
end
