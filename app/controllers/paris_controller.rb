class ParisController < ApplicationController
  def show
  	Rails.logger.debug('===========> IN CONTROLLER paris controller')
  	Rails.logger.debug('Sport = ' + params[:name])

  	@sportName = params[:name]
  	@events = Robot.get_events(params[:name])
  end
end
