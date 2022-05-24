class ChangeDataDateToJapanMeteorologicalAgencies < ActiveRecord::Migration[7.0]
  def change
    change_column :japan_meteorological_agencies, :date, :Date
  end
end
