class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.date :date
      t.integer :hour
      t.decimal :temperature, precision: 5, scale: 2
      t.decimal :dew_point, precision: 5, scale: 2
      t.integer :humidity
      t.integer :wind_direction
      t.integer :wind_speed
      t.decimal :visibility, precision: 5, scale: 2
      t.decimal :air_pressure, precision: 5, scale: 2
      t.decimal :humidex, precision: 5, scale: 2
      t.decimal :wind_chill, precision: 5, scale: 2
      t.string :weather
      t.references :station, index: true

      t.timestamps
    end

    add_index :measurements, [:station_id, :date, :hour], unique: true
  end
end
