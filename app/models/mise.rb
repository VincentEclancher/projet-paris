class Mise
	def self.controleMise(laMise, userId, betId)
		puts '------------------------------------------------------Mise : ' + laMise + '---------------------------------'
		user = User.find(userId)
		puts '------------------------------------------------------Username : ' + user.username + '----------------------'
		puts '------------------------------------------------------Username : ' + user.credit.to_s + '----------------------'
		laMise = laMise.to_f
		if (laMise < 0.5)
			estMise = 0
		else 
			if (laMise > user.credit)
				puts '-------------------------------------- PAS ASSEZ D\'ARGENT ---------------------------------'
				estMise = -1
			else
				user.credit = user.credit-laMise
				user.save

				lePari = Odd.find(betId)
				leMatch = Bet.find(lePari.bet_id)
				monPari = BetUser.new
				monPari.user_id = userId
				monPari.bet_id = betId
				monPari.match = leMatch.match_name
				monPari.prono = lePari.name
				monPari.cote = lePari.odd
				monPari.mise = laMise
				monPari.gain = (laMise*lePari.odd).round(2)
				monPari.save
				estMise = 1
			end
		end
		return estMise
	end
end