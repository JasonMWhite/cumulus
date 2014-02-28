require 'csv'
require 'ftp'

namespace :weather do
  namespace :us do
    desc "Retrieve us weather meta-data"
    task :update_weather => :environment do
      data = get_station_data
      data_array = parse_station_data(data)
    end

    def get_station_data
      Net::FTP.open('ftp.ncdc.noaa.gov') do |ftp|
        ftp.login
        files = ftp.chdir('/pub/data/uscrn/products/')
        ftp.get_string_content('stations.tsv')
      end
    end

    def parse_station_data(data)
      first_line = true
      data_array = []
      CSV.parse(data, { col_sep: "\t", quote_char: '|' }) do |line|
        if first_line
          first_line = false
        else
          data_hash = {
            wban: line[0],
            country: line[1],
            state: line[2],
            location: line[3],
            vector: line[4],
            name: line[5],
            latitude: line[6],
            longitude: line[7],
            elevation: line[8],
            status: line[9],
            commisioning_closing: line[10],
            operation: line[11],
            pairing_network: line[12]
          }
          data_array << data_hash
        end
      end
      data_array
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

    desc "testing ftp"
    task :test_ftp_download do
      Net::FTP.open('ftp.ncdc.noaa.gov') do |ftp|
        ftp.login
        files = ftp.chdir('/pub/data/uscrn/products/')
        stations = ftp.get_string_content('stations.tsv')
        puts stations
      end
    end
  end
end