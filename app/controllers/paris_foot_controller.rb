class ParisFootController < ApplicationController
  def get_paris_foot
  	Rails.logger.debug('===========> IN CONTROLLER')
    
	matchs = Robot.last_matchs
    render :json => matchs
  end
end
