require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'date'
require 'ri_cal'
require 'httpclient'


TERMINE_URL = 'http://kbu.freifunk.net/index.php?title=Treffen&action=raw'
LOCATION_DATA = {
  'termin-c4' => 'Heliosstr. 6a, 50825 Koeln',
  'termin-bn' => 'Wolfstr 10, 53111 Bonn'
}
BEGIN_TIME = "20:00"
END_TIME = "23:23"

#{{Treffen 
#|termin-c4 = 09.02.2012
#|termin-bn = 01.03.2012 
#}}
#[[Kategorie:Kontakt]]



configure do
  mime_type :ical, "text/calendar"
  set :logging, true
end

get '/:pattern.ical' do |pattern|
  content_type :ical #Content-Type setzen
  
  clnt = HTTPClient.new  
  data_str = clnt.get(TERMINE_URL).body
  
  cal = RiCal.Calendar do |cal| 
    parse_str(data_str).each do |e|
      cal.event do |event|
        event.summary = "Freifunk KBU"
        event.dtstart = Time.parse("#{e[:date]} #{BEGIN_TIME}").getutc
        event.dtend = Time.parse("#{e[:date]} #{END_TIME}").getutc
        event.location = e[:location]
      end
    end
  end
  cal.to_s
end

private
def parse_str(str)
  result = []
  lines = str.split "|"
  lines.each do |line|
    (location,dates) = line.split "="
    location.strip! unless location.nil?
    dates.chomp! unless dates.nil?
    location = LOCATION_DATA[location] || location
    unless dates.nil?
      dates.split(',').each do |date|
        result << {:location => location, :date => date}
      end
    end
  end
  return result
end
