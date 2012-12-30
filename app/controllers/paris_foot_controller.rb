class ParisFootController < ApplicationController
  def get_paris_foot
  	Rails.logger.debug('===========> IN PARIS FOOT CONTROLLER')
  	Rails.logger.debug('=======================================')
    
	@events = Robot.last_matchs
	@events
  end
end
