class MiseController < ApplicationController
  before_filter :authenticate_user!

  def mise  
    Rails.logger.debug('===========> In mise controller')

	@resultatMise = Mise.controleMise(params[:mise], params[:user_id])
  end
  
end