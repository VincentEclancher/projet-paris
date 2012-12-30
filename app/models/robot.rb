class Robot
  def self.get_events(sport)
    i = self.new

    i.fetch(sport)
  end

  def self.sports
    i = self.new

    i.get_sports
  end

  def get_sports
    @url = "http://xml.betclick.com/odds_fr.xml"

    cache_raw = Rails.cache.read('raw_xml')

    if not cache_raw
        Rails.logger.debug('===========> HTTP CALL')
        # Rails.cache.write('raw_xml', @response, :expires_in => 1000.minutes)
    end

    # @response = HTTParty.get(@url) # BLOCKING
    # @body = @response.body
    @body = File.read(Rails.root.join('sports.xml'))

    self.parse_sports
  end

  def fetch(sport)
    @sportName = sport
    @url = "http://xml.betclick.com/odds_fr.xml"

    cache_raw = Rails.cache.read('raw_xml')

    if not cache_raw
        Rails.logger.debug('===========> HTTP CALL')
        # Rails.cache.write('raw_xml', @response, :expires_in => 1000.minutes)
    end

    # @response = HTTParty.get(@url) # BLOCKING
    # @body = @response.body
    @body = File.read(Rails.root.join('sports.xml'))
    
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

  def parse
    @events = []


    Rails.logger.debug('In parse method !')

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)

    Rails.logger.debug('SPORT =====> ' + @sportName)

    betTypeRegexp = /(.*_Win|.*_Mr3|.*_Mr2|.*_Mr6|.*_Mrs|.*_Rwi|.*_Hhr|.*_Pl3)/ 
    betMr3Regexp = /.*Mr3/

    doc.xpath("//sports//sport[@name='#{@sportName}']//event").each do |event|
        Rails.logger.debug("Event name = " + event['name'])
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


                        choiceName = choice["name"]
                        if choiceName.match("%1%")     ## Equipe 1 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team1 = matchName.split(%r{\s-\s})[0]
                            theMatch.teamsAndOdds[team1] = choice["odd"]
                        elsif choiceName.match("%2%")   ## Equipe 2 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team2 = matchName.split(%r{\s-\s})[1]
                            theMatch.teamsAndOdds[team2] = choice["odd"]
                        elsif choiceName.match("Nul")   ## Côte du match nul pour un match de type "Résultat" (1-Nul-2)
                            theMatch.oddNul = choice["odd"]
                        else    ##Tout autre type de paris (ex win)
                            theMatch.teamsAndOdds[choiceName] = choice["odd"]
                        end
                    end
                end
            end
            @theEvent.matchs.push(theMatch)
        end
        @events.push(@theEvent)
    end

    @events
  end
end

