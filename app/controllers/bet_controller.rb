class BetController < ApplicationController
before_filter :authenticate_user!
  def show
    Rails.logger.debug('----------------------------------')
    Rails.logger.debug('IN BET CONTROLLER !')

  	Rails.logger.debug('>>>>>> Sport = ' + params[:sport])
  	Rails.logger.debug('>>>>>> Bet id = ' + params[:id])
    Rails.logger.debug('----------------------------------')

	returnValues = Robot.get_bet(params[:id])
  @sportName = params[:sport]
	@bet = returnValues[0]
	@odd = returnValues[1]

  end
end