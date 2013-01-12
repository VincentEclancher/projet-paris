class BetController < ApplicationController

  def show
    Rails.logger.debug('IN BET CONTROLLER !')

  	Rails.logger.debug('>>>>>> Sport = ' + params[:sport])
  	Rails.logger.debug('>>>>>> Bet id = ' + params[:id])

	@sportName = params[:sport]
  	@bet = Robot.get_bet(params[:sport], params[:id])
  end
end