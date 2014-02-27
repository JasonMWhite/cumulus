class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :province
      t.decimal :latitude, precision: 5, scale: 2
      t.decimal :longitude, precision: 5, scale: 2
      t.decimal :elevation, precision: 6, scale: 2
      t.integer :climate_identifier
      t.integer :wmo_identifier
      t.integer :ec_identifier
      t.string :tc_identifier

      t.timestamps
    end
  end
end
