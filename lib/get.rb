require 'net/http'
require 'json'


url = "http://localhost:3000/paris/football"
uri = URI(url)
while true
	html = Net::HTTP.get(uri)
	puts 'Pass ...'
	sleep(5)
end