class Parser
	def self.parse_xml()
		i = self.new
		puts "In parse_xml method"

		#Fetch XML via url if necessary
		i.fetch_xml
		puts ">>>> Done : URL fetched"
		
		i.get_sports
		puts ">>>> Done : Got all sports names"
		
		i.parse_sports
		puts ">>>> Done : Parsed all sports and updated DB"
	end

   	def parse_sports
   		@sports.each do |sport|
			puts ">>>> Going to fetch sport "  
			parse(sport)
			puts ">>>> Done : sport  has been fetched"
		end
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
    @sports = []

    Rails.logger.debug('In parse SPORTS method !')

    doc = Nokogiri::XML(@body)

    doc.xpath("//sports//sport").each do |sport|
        @sports.push(sport['name'])
    end
    @sports
    
  end

  ## Cette méthode parcourt le fichier XML à la recherche de tous les
  ## paris associés au sport passé en paramètre, et pour chaque pari
  ## elle vérifie si les paris existent dans la base de données.
  ## Si oui ils sont simplement ignorés, sinon ils sont créés. 
  def parse(sport)
    Rails.logger.debug('In parse method !')

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)

    puts "Parsing sport : " + sport
    Rails.logger.debug('SPORT =====> ' + sport)

    betTypeRegexp = /(.*_Win|.*_Mr3|.*_Mr2|.*_Mr6|.*_Mrs|.*_Rwi|.*_Hhr|.*_Pl3)/ 
    betMr3Regexp = /.*Mr3/

    doc.xpath("//sports//sport[@name='#{sport}']//event").each do |event|
        event.css("match").each do |match| 
            hasBet = false


            matchName = match['name']

            match.css("bets bet").each do |bet|

                codeName = bet["code"]

                if codeName.match(betTypeRegexp) && !hasBet

                    theBet = Bet.new 

                    hasBet = true

                    codeNameShort = codeName.split(%r{_})[1]

                    #On prépare l'objet "bet" qui sera inséré dans la base de données
                    theBet.bet_id = bet["id"]
                    theBet.type_of_bet = codeNameShort
                    theBet.sport_name = sport
                    theBet.event_name = event['name']
                    theBet.match_name = match['name']
                    theBet.match_id = match['id']
                    theBet.start_date = match['start_date'].split("T")[0]
                    theBet.start_time = match['start_date'].split("T")[1]

                    bet.css("choice").each do |choice|

                        theOdd = Odd.new
                        theOdd.odd_id = choice["id"]
                        theOdd.bet_id = theBet.bet_id
                        theOdd.odd = choice["odd"]

                        choiceName = choice["name"]
                        theOdd.init_name = choiceName
                        if choiceName.match("%1%")     ## Equipe 1 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team1 = matchName.split(%r{\s-\s})[0]
                            theOdd.name = team1
                        elsif choiceName.match("%2%")   ## Equipe 2 d'un match de type "Résultat" (1-2 ou 1-Nul-2)
                            team2 = matchName.split(%r{\s-\s})[1]
                            theOdd.name = team2
                        elsif choiceName.match("Nul")   ## Côte du match nul pour un match de type "Résultat" (1-Nul-2)
                            theOdd.name = choiceName
                        else    ##Tout autre type de paris (ex win)
                            theOdd.name = choiceName
                        end
                        if not theOdd.name
                            theOdd.name = "Name not found !"
                        end 
                        if Odd.exists?(theOdd.odd_id)
                            existingOdd = Odd.find(theOdd.odd_id)
                            existingOdd.odd = theOdd.odd
                        else
                            theOdd.save
                        end
                    end
                    if not Bet.exists?(theBet.bet_id)
                        theBet.save
                    end
                end
            end
        end
    end
  end
end