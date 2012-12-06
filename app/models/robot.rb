class Robot
  def self.last_matchs
    i = self.new

    i.fetch
  end

  def fetch
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

  def parse
    @matchs = []

    Rails.logger.debug('In parse method !')

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)


    doc.xpath("//sports//sport[@name='Football']//event[@name='Ligue 1']//match").each do |match|
        bet = match.css("bets bet")[0]

        theMatch = Match.new
        matchName = match['name']
        theMatch.name = matchName
        theMatch.team1 = matchName.split(%r{\s-\s})[0]
        theMatch.team2 = matchName.split(%r{\s-\s})[1]
        odd1 = bet.css("choice")[0]
        oddNul = bet.css("choice")[1]
        odd2 = bet.css("choice")[2]
        theMatch.odd1 = odd1['odd']
        theMatch.oddNul = oddNul['odd']
        theMatch.odd2 = odd2['odd']
        theMatch.date = match['start_date'].split("T")[0]
        theMatch.time = match['start_date'].split("T")[1]

        @matchs.push(theMatch)
    end

    @matchs
  end
end

