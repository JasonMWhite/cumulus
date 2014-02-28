require 'net/ftp'
require 'csv'


desc "Retrieve us weather meta-data"
task :update_weather_us => :environment do
  # Net::FTP.open('ftp.ncdc.noaa.gov') do |ftp|
  #   ftp.login
  #   files = ftp.chdir('/pub/data/uscrn/products/')
  #   puts ftp.gettextfile('stations.tsv')
  # end


  # read the metadata file
  CSV.foreach("us_stations.csv") do |row|
    update_station_attributes(row)
  end

end


def update_station_attributes(rec)
  attributes = {
    national_station_id: rec[1],
    country: rec[2],
    province: rec[3],
    name: rec[4],
    latitude: rec[5],
    longitude: rec[6],
    elevation: rec[7]
  }
  puts attributes
  Station.create(attributes)
end
    

 