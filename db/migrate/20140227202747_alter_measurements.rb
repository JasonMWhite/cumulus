class AlterMeasurements < ActiveRecord::Migration
  def up
    change_table :measurements do |t|
      t.rename  :date, :date_lst
      t.rename  :hour, :hour_lst
      t.date    :date_utc
      t.integer :hour_utc
      t.integer :precipitation
      t.integer :solar_radiation
    end
  end

  def down
    change_table :measurements do |t|
      t.rename  :date_lst, :date
      t.rename  :hour_lst, :hour
      t.remove  :date_utc
      t.remove  :hour_utc
      t.remove  :precipitation
      t.remove  :solar_radiation
    end
  end
end
