class Cleaner
	def self.clean_database
		puts "Starting clean of database"

		timeNow = Time.new

		bets = Bet.select("bet_id, is_opened").where("is_opened = 't' AND :time_now >= start_date",
			{:time_now => timeNow})
		puts ">>>> Going to close " + bets.length.to_s + " bets"

		betsIds = []
		bets.each do |bet|
			betsIds.push(bet.bet_id)
		end

		betsIds.each do |betId|
			theBet = Bet.find(betId)
			theBet.is_opened = false
			theBet.save
		end

		puts ">>> Done : Database cleaned !"
	end
end
