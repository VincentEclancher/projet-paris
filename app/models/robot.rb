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
    Rails.logger.debug(">>>>>>> Tableau sportif <<<<<<<")

    # cache = Rails.cache.read('raw_xml')
    doc = Nokogiri::XML(@body)


    doc.xpath("//sports//sport[@name='Football']//event[@name='Ligue 1']//match").each do |sport|
        # Rails.logger.debug(sport.search('//event').first['name'])
        Rails.logger.debug(sport['name'])
    end

    @matchs
  end
end