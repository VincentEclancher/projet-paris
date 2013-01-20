class Scheduler
	def self.schedule
		t = Thread.new do
		  while true do
		    p 'Should call the method parse_xml'
		    Parser.parse_xml
		    sleep 4000
		  end
		end
		t.run
	end
end

