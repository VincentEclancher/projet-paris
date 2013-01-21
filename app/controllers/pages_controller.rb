class PagesController < ApplicationController

  def index
    Rails.logger.debug('===========> HTTP INDEX')

    @sports = Robot.get_sports
    @sports
  end
end