desc "Retrieve Canadian station identifiers with hourly data"
task :get_canadian_stations => :environment do 
  conn = Faraday.new(:url => 'http://climate.weather.gc.ca') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
  conn.headers[:user_agent] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'

  startRow = 1
  finished = false
  while !finished do
    response = conn.get('/advanceSearch/searchHistoricDataStations_e.html', {searchType: 'stnProv', 'Year' => 2014, 'Month' => 2, 'Day' => 26, selRowPerPage: 100, cmdProvSubmit: 'Search', startRow: startRow})
    html = Nokogiri::HTML.parse(response.body)
    nodes = html.root.xpath('//form[substring(@id,1,10)= "stnRequest"][.//select[@name="timeframe"]/option[normalize-space(text()) = "Hourly"]]/div/input[@name="StationID"]/@value')
    stations = nodes.map { |node| node.value.to_i }

    stations.each do |station_id|
      if Station.find_by(ec_identifier: station_id).nil?
        Station.create(ec_identifier: station_id)
      end
    end
    startRow += 100
    finished = (stations.length == 0)
  end
end
