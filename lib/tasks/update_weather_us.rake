require 'net/ftp'

desc "Retrieve us weather meta-data"
task :update_weather_us => :environment do
  Net::FTP.open('ftp.ncdc.noaa.gov') do |ftp|
    ftp.login
    files = ftp.chdir('/pub/data/uscrn/products/')
    puts ftp.gettextfile('stations.tsv')
  end

  f = File.open("stations.tsv", "r")
  f.each_line do |line|
    rec = line.chop.split("\t")
  end
  f.close
  
end