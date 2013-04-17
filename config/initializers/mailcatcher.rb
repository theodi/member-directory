if Rails.env.development?
  # Detect mailcatcher and send to it if it's running
  begin
    sock = TCPSocket.new("localhost", 1025)
    sock.close
    ActionMailer::Base.smtp_settings = { :host => "localhost", :port => '1025' }
  rescue
  end
end