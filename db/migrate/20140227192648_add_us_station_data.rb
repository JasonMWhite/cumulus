class AddUsStationData < ActiveRecord::Migration

  def up
    change_table :stations do |t|
      t.rename :ec_identifier, :national_station_id
      t.column :country, :string
    end
  end

  def down
    change_table :stations do |t|
      t.rename :national_station_id, :ec_identifier
      t.remove :country
    end
  end
end
        
      