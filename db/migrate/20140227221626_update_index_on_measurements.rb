class UpdateIndexOnMeasurements < ActiveRecord::Migration
  def up
    execute "ALTER TABLE measurements DROP INDEX index_measurements_on_station_id_and_date_lst_and_hour_lst"
    add_index(:measurements, [:station_id, :date_lst])
  end

  def down
    execute "ALTER TABLE measurements DROP INDEX index_measurements_on_station_id_and_date_lst_and_hour_lst"
  end
end
