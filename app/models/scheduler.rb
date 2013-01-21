class Scheduler
	def self.schedule_parse
		parseThread = Thread.new do
		  	while true do
			    p 'Should call the method parse_xml'
			    Parser.parse_xml
			    sleep 4000
		  	end
		end
		parseThread.run
	end

	def self.schedule_clean
		cleanThread = Thread.new do
			while true do
				p 'Should call the method clean_database'
				Cleaner.clean_database
				sleep 600
			end
		end
		cleanThread.run
	end
end

