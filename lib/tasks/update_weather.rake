require 'benchmark'
logger = Logger.new(STDOUT)

namespace :weather do
  namespace :canada do  
    desc "Retrieve new weather data"
    task :update_weather => :environment do
      conn = Faraday.new(:url => 'http://climate.weather.gc.ca') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      conn.headers[:user_agent] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'

      Station.all.each do |station|
        last_measurement = station.measurements.order("date_lst DESC, hour_lst DESC").first
        last_date = last_measurement.nil? ? Date.new(2013,1,1) : last_measurement[:date_lst]
        start_time = Time.now

        last_measurement = station.measurements.order("date_lst DESC, hour_lst DESC").first
        last_date = last_measurement.nil? ? Date.new(2013,1,1) : last_measurement[:date_lst]
        logger.info "[Benchmarking] Station setup complete in #{Time.now - start_time} seconds"

        (Date.new(last_date.year, last_date.month, 1)..Date.today).select {|d| d.day == 1}.each do |date|
          start_time = Time.now
          response = conn.get('/climateData/bulkdata_e.html', {format: 'xml', stationID: station.national_station_id, 'Year' => date.year, 'Month' => date.month, 'Day' => date.day, timeframe: 1, submit: 'Download Data'})
          logger.info "[Benchmarking] Data retrieved in #{Time.now - start_time} seconds"
          start_time = Time.now

          doc = Nokogiri::XML.parse(response.body)
          if station.name.nil?
            station_node = doc.root.at_xpath('./stationinformation')
            update_station_attributes(station, station_node)
            station.save!
          end
          logger.info "[Benchmarking] station saved in #{Time.now - start_time} seconds"
          start_time = Time.now

          doc.root.xpath('./stationdata').each do |data_node|
            data_date = Date.new(data_node.attr('year').to_i, data_node.attr('month').to_i, data_node.attr('day').to_i)
            hour = data_node.attr('hour_lst').to_i
            m = Measurement.find_by(station_id: station.id, date_lst: data_date, hour_lst: hour) || station.measurements.new(date_lst: data_date, hour_lst: hour)
            update_measurement_attributes(m, data_node)
            m.save!
          end
          logger.info "[Benchmarking] measurement data saved in #{Time.now - start_time} seconds"
        end
      end
    end

    def update_station_attributes(station, node)
      node.children.each do |child|
        case child.name
        when 'name', 'province', 'tc_identifier'
          station.attributes = {child.name.to_s => child.inner_text}
        when 'latitude', 'longitude', 'elevation'
          station.attributes = {child.name.to_s => child.inner_text.to_f}
        when 'climate_identifier', 'wmo_identifier'
          station.attributes = {child.name.to_s => child.inner_text.to_i}
        end
      end
    end 

    def update_measurement_attributes(measurement, node)
      node.children.each do |child|
        if child.inner_text.present?
          case child.name
          when 'temp'
            measurement.temperature = child.inner_text.to_f
          when 'dptemp'
            measurement.dew_point = child.inner_text.to_f
          when 'relhum'
            measurement.humidity = child.inner_text.to_i
          when 'winddir'
            measurement.wind_direction = child.inner_text.to_i * 10
          when 'windspd'
            measurement.wind_speed = child.inner_text.to_i
          when 'visibility'
            measurement.visibility = child.inner_text.to_f
          when 'stnpress'
            measurement.air_pressure = child.inner_text.to_f
          when 'humidex'
            measurement.humidex = child.inner_text.to_f
          when 'windchill'
            measurement.wind_chill = child.inner_text.to_f
          when 'weather'
            measurement.weather = child.inner_text
          end
        end
      end
    end
  end
end