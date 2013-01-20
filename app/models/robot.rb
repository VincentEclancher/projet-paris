class Robot
  def self.get_events(sport)
    i = self.new

    i.fetch(sport)
  end

  def self.sports
    i = self.new

    i.get_sports
  end

  def self.get_bet(sportName, betId)
    i = self.new
    i.fetch_xml

    i.parse_bet(sportName, betId)
  end

  def fetch_xml
    @url = "http://xml.betclick.com/odds_fr.xml"

    cache = Rails.cache.read('raw')

    if cache
        Rails.logger.debug('===========> CACHE Exists, use it')
        @body = cache
    else
        Rails.logger.debug('===========> CACHE does not exist, fetch it from URL')
        @response = HTTParty.get(@url) # BLOCKING
        Rails.cache.write('raw', @response.body.to_s, :expires_in => 60.minutes)
        @body = @response.body.to_s
    end
  end

  def get_sports
    fetch_xml

    self.parse_sports
  end

  def fetch(sport)
    @sportName = sport
    fetch_xml
    
    self.parse
  end

  def parse_sports
    @sports = []

    Rails.logger.debug('In parse SPORTS method !')

    doc = Nokogiri::XML(@body)

    doc.xpath("//sports//sport").each do |sport|
        @sports.push(sport['name'])
    end
    @sports
    
  end

  def parse_bet(sport, betId)
    Rails.logger.debug('In parse BET method ! ' + betId)
    Rails.logger.debug('----------------------------------')

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)

    theBet = Bet.new
    theBet.id = -1

    doc.xpath("//sports//sport[@name='#{sport}']//choice[@id='#{betId}']").each do |bet|        
        Rails.logger.debug('>> Found something !')
        Rails.logger.debug('>> Bet odd : ' + bet['odd'])
        Rails.logger.debug('>> Parent id : ' + bet.parent()['name'])

        match = bet.parent().parent().parent()
        matchString = match['name']
        event = match.parent()

        choiceName = bet["name"]
        if choiceName.match("%1%")     ## Equipe 1 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
            theBet.teamName = matchString.split(%r{\s-\s})[0]
        elsif choiceName.match("%2%")   ## Equipe 2 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
            theBet.teamName = matchString.split(%r{\s-\s})[1]
        elsif choiceName.match("Nul")   ## Côte du match nul pour un match de type "Résultat" (1-Nul-2)
            theBet.teamName = "Nul"
        else    ##Tout autre type de paris (ex win)
            theBet.teamName = bet['name']
        end
        betCode = bet.parent()['code']

        theBet.id           = betId
        theBet.odd          = bet['odd']
        theBet.matchName    = match['name']
        theBet.eventName    = event['name']
        theBet.betType      = betCode.split(%r{_})[1]
        theBet.matchDate    = match['start_date'].split("T")[0]
        theBet.matchTime    = match['start_date'].split("T")[1]
    end

    Rails.logger.debug('----------------------------------')

    return theBet
  end

  def parse
    @events = []

    Rails.logger.debug('In parse method !')

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)

    Rails.logger.debug('SPORT =====> ' + @sportName)

    betTypeRegexp = /(.*_Win|.*_Mr3|.*_Mr2|.*_Mr6|.*_Mrs|.*_Rwi|.*_Hhr|.*_Pl3)/ 
    betMr3Regexp = /.*Mr3/

    doc.xpath("//sports//sport[@name='#{@sportName}']//event").each do |event|
        @theEvent = Event.new
        @theEvent.matchs = []
        @theEvent.name = event['name']
        @theEvent.id = event['id']
        if event['start_date']
            @theEvent.start_date = event['start_date']
        end

        event.css("match").each do |match|
            hasBet = false

            theMatch = Match.new

            #On remplit les champs de l'objet Match
            theMatch.name = match['name']
            theMatch.id = match['id']
            theMatch.date = match['start_date'].split("T")[0]
            theMatch.time = match['start_date'].split("T")[1]

            matchName = match['name']

            match.css("bets bet").each do |bet|

                codeName = bet["code"]

                #Rails.logger.debug("Code = " + codeName)

                if codeName.match(betTypeRegexp) && !hasBet

                    hasBet = true

                    codeNameShort = codeName.split(%r{_})[1]

                    theMatch.teamsAndOdds = Hash.new

                    theMatch.typeOfBet = codeNameShort

                    bet.css("choice").each do |choice|

                        theOdd = Odd.new
                        theOdd.id = choice["id"]
                        theOdd.name = choice["name"]
                        theOdd.odd = choice["odd"]

                        choiceName = choice["name"]
                        if choiceName.match("%1%")     ## Equipe 1 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team1 = matchName.split(%r{\s-\s})[0]
                            theMatch.teamsAndOdds[team1] = theOdd
                        elsif choiceName.match("%2%")   ## Equipe 2 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team2 = matchName.split(%r{\s-\s})[1]
                            theMatch.teamsAndOdds[team2] = theOdd
                        elsif choiceName.match("Nul")   ## Côte du match nul pour un match de type "Résultat" (1-Nul-2)
                            theMatch.oddNul = theOdd
                        else    ##Tout autre type de paris (ex win)
                            theMatch.teamsAndOdds[choiceName] = theOdd
                        end
                    end
                end
            end
            if hasBet
                @theEvent.matchs.push(theMatch)
            end
        end
        @events.push(@theEvent)
    end

    @events
  end
end

