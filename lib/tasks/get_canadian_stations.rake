desc "Retrieve Canadian station identifiers with hourly data"
task :get_canadian_stations => :environment do 
  conn = Faraday.new(:url => 'http://climate.weather.gc.ca') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
  conn.headers[:user_agent] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'

  
  
end