# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140227221626) do

  create_table "measurements", force: true do |t|
    t.date     "date_lst"
    t.integer  "hour_lst"
    t.decimal  "temperature",     precision: 5, scale: 2
    t.decimal  "dew_point",       precision: 5, scale: 2
    t.integer  "humidity"
    t.integer  "wind_direction"
    t.integer  "wind_speed"
    t.decimal  "visibility",      precision: 5, scale: 2
    t.decimal  "air_pressure",    precision: 5, scale: 2
    t.decimal  "humidex",         precision: 5, scale: 2
    t.decimal  "wind_chill",      precision: 5, scale: 2
    t.string   "weather"
    t.integer  "station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_utc"
    t.integer  "hour_utc"
    t.integer  "precipitation"
    t.integer  "solar_radiation"
  end

  add_index "measurements", ["station_id", "date_lst"], name: "index_measurements_on_station_id_and_date_lst", using: :btree
  add_index "measurements", ["station_id"], name: "index_measurements_on_station_id", using: :btree

  create_table "stations", force: true do |t|
    t.string   "name"
    t.string   "province"
    t.decimal  "latitude",            precision: 5, scale: 2
    t.decimal  "longitude",           precision: 5, scale: 2
    t.decimal  "elevation",           precision: 6, scale: 2
    t.integer  "climate_identifier"
    t.integer  "wmo_identifier"
    t.integer  "national_station_id"
    t.string   "tc_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

end
