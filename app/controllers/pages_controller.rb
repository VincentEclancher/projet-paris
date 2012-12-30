class PagesController < ApplicationController

  def index
    Rails.logger.debug('===========> HTTP INDEX')

    @sports = Robot.sports
    @sports
  end
end