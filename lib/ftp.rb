require 'net/ftp'
require 'stringio'

class Net::FTP
  def get_string_content(remote_file)
    s = StringIO.new
    retrlines("RETR #{remote_file}") { |line| s.write("#{line}\r\n") }
    s.string
  end
end
