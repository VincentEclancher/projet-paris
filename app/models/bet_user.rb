class BetUser < ActiveRecord::Base
	set_table_name "bets_users"

	def self.listParis(userId)
		betsUsersObjects = []
	    #On récupère tous les paris de l'utilisateur
	    betsUsersRowid = BetUser.select(:id).where(:user_id => userId).order(:created_at).uniq
	    betsUsersRowid.each do |id|
	    	lePari = BetUser.find(id)
	    	puts '------------------------------------- lePari : '+lePari.match+' ------------------------------------------'
        	betsUsersObjects.push(lePari)
    	end
        return betsUsersObjects
	end
end