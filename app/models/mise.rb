class Mise
	def self.controleMise(laMise, userId)
		puts '------------------------------------------------------Mise : ' + laMise.to_s + '---------------------------------'
		user = User.find(userId)
		case laMise
		when laMise < 0.5
			estMise = 0
		when laMise > user.credit
			estMise = -1
		else
			user.credit = user.credit-laMise
			user.save
			estMise = 1
		end
		return estMise
	end
end