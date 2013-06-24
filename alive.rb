#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'httparty'

# Konfiguration
max_diff = 1500 # Zeitabstand in Sekunden, in der sich der server gemeldet haben muss

modtime = File.mtime('/home/tjark/alive/alive')
time = Time.now
diff = (time - modtime).to_i


if diff > 1500 && !FileTest.exists?('/home/tjark/alive/notalive')
    SETTINGS = { :username => 'mail@mail.com', :password => 'password' }
  
    NOTIFICATION_URL = 'https://boxcar.io/notifications'

    notification_params = { :notification => { :from_screen_name => 'Server-Monitoring', :message => 'Der Server Bramel ist nicht mehr aktiv.' } }
    resp = HTTParty.post(NOTIFICATION_URL, :body => notification_params, :basic_auth => SETTINGS)
    puts resp
    
    File.new('/home/tjark/alive/notalive', 'w').close
elsif diff <= 1500 && FileTest.exists?('/home/tjark/alive/notalive')
    File.delete('/home/tjark/alive/notalive')
end
