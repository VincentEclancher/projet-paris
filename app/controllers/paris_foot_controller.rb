class ParisFootController < ApplicationController
  def get_paris_foot
  	Rails.logger.debug('===========> IN PARIS FOOT CONTROLLER')
  	Rails.logger.debug('=======================================')
    
	@matchs = Robot.last_matchs
	@matchs
  end
end
