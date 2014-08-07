#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'httparty'

# Konfiguration
max_diff = 1500 # Zeitabstand in Sekunden, in der sich der server gemeldet haben muss
alive_file = '/home/tjark/alive/alive' # Datei, die bei Server-Meldung aktualisiert wird
notalive_file = '/home/tjark/alive/notalive' # Datei, um wiederholte Benachrichtigungen zu vermeiden. Skript braucht Schreibrecht auf den Ordner
boxcar_user = 'mail@mail.com' # Boxcar-Benutzername
boxcar_password = 'password' # Boxcar-Passwort
boxcar_title = 'Server-Monitoring' # Titel der Boxcar-Benachrichtigung
boxcar_name = 'XYZ.' # Name des Servers

$SETTINGS = { :username => boxcar_user, :password => boxcar_password } # Bitte nicht ändern

# Vergangene Zeit seit der letzten Dateiänderung berechnen
modtime = File.mtime(alive_file)
time = Time.now
diff = (time - modtime).to_i


# Wir prüfen, ob die maximale Zeit bereits abgelaufen ist und nicht bereits benachrichtigt wurde
if diff > max_diff && !FileTest.exists?(notalive_file)
    # Benachrichtigung bauen...
    notification_params = { :notification => { :from_screen_name => boxcar_title, :message => 'Der Server #{boxcar_name} ist nicht mehr aktiv.' } }
    # ...und herausschicken
    notificate(notification_params)
    # Datei erstellen, damit wird wissen, dass wir bereits benachrichtigt haben
    File.new(notalive_file, 'w').close
# Wenn die maximale Zeit nicht abgelaufen ist, aber wir vor kurzem benachrichtigt haben...
elsif diff <= max_diff && FileTest.exists?(notalive_file)
    # ... löschen wir die Datei, damit wir nächstes mal wieder benachrichtigen
    File.delete(notalive_file)
    # Benachrichtigung bauen...
    notification_params = { :notification => { :from_screen_name => boxcar_title, :message => 'Der Server #{boxcar_name} ist wieder aktiv.' } }
    # ...und herausschicken
    notificate(notification_params)
end

# Notifiziert eine übergebene Benachrichtigung
def notificate(params)
    resp = HTTParty.post('https://boxcar.io/notifications', :body => params, :basic_auth => $SETTINGS)
    puts resp
end
