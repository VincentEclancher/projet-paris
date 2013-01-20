class Robot 

  ## Récupère tous les sports ayant des paris associés.
  ## Fait une requête select sur tous les paris pour ça.
  ## (de type 'SELECT DISTINCT sport_name FROM bets')
  def self.get_sports
    puts 'In method get_sports'

    sports = []

    betsObjects = Bet.select(:sport_name).uniq
    betsObjects.each do |sport|
        sports.push(sport.sport_name)
    end
    return sports
  end

  ## Récupère un pari et sa côte associée pour un pari en particulier,
  ## grâce à l'id du pari passé en paramètre.
  ## Fait une requête select sur tous les paris pour ça.
  ## (de type 'SELECT * FROM odds where bet_id=xxxx')
  def self.get_bet(oddId)
    puts 'In method get_bet'

    returnValues = []

    theBet = Bet.new
    theOdd = Odd.new
    if Odd.exists?(oddId)
        theOdd = Odd.find(oddId)

        if Bet.exists?(theOdd.bet_id)
            theBet = Bet.find(theOdd.bet_id)
        end
    end

    returnValues.push(theBet)
    returnValues.push(theOdd)

    Rails.logger.debug('----------------------------------')

    return returnValues
  end


  ## Récupère tous les évènements sportifs liés à un certain sport, à partir de la base.
  ## Fait une requête select sur tous les paris pour ça.
  ## Cette méthode permet de préparer des objets Event et Match pour l'affichage dans les vues
  def self.get_events(sport)
    puts 'In method get_events'

    eventsNames = []

    #On récupère tous les différents évènements correspondants au sport
    betsObjects = Bet.select(:event_name).where(:sport_name => sport).uniq
    betsObjects.each do |event|
        eventsNames.push(event.event_name)
    end

    events = []
    eventsNames.each do |eventName|
        theEvent = Event.new
        theEvent.name = eventName
        theEvent.matchs = []

        bets = Bet.select(:match_id).where(:sport_name => sport, :event_name => eventName)
        matchsIds = []
        bets.each do |matchId|
            matchsIds.push(matchId.match_id)
        end

        hasDateAndTime = false

        ## On récupère les matchs d'un évènement
        matchsIds.each do |matchId|
            theMatch = Match.new
            theMatch.id = matchId

            bets = Bet.where(:sport_name => sport, :event_name => eventName, :match_id => matchId)
            theMatch.name = bets.first.match_name
            date = bets.first.start_date.to_s
            time = bets.first.start_time.to_s
            timeInter = time.split(" ")[1]

            theMatch.date = date.split("-")[2] + "/" + date.split("-")[1] + "/" + date.split("-")[0] 
            theMatch.time = timeInter.split(":")[0] + "h" + timeInter.split(":")[1]

            if !hasDateAndTime
                theEvent.start_date = theMatch.date
                hasDateAndTime = true
            end
            
            ## On récupère tous les paris d'un match
            bets.each do |bet|
                theMatch.teamsAndOdds = Hash.new
                theMatch.typeOfBet = bet.type_of_bet

                odds = Odd.where(:bet_id => bet.bet_id)
                odds.each do |theOdd|
                    if theOdd.init_name.match("%1%")     ## Equipe 1 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                        team1 = theOdd.name
                        theMatch.teamsAndOdds[team1] = theOdd
                    elsif theOdd.init_name.match("%2%")   ## Equipe 2 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                        team2 = theOdd.name
                        theMatch.teamsAndOdds[team2] = theOdd
                    elsif theOdd.init_name.match("Nul")   ## Côte du match nul pour un match de type "Résultat" (1-Nul-2)
                        theMatch.oddNul = theOdd
                    else    ##Tout autre type de paris (ex win)
                        theMatch.teamsAndOdds[theOdd.name] = theOdd
                    end
                end
            end
            theEvent.matchs.push(theMatch)
        end
        events.push(theEvent)
    end
    return events
  end
end
