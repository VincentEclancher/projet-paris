class RobotController < ApplicationController
  def index
    films = Robot.last_films
    render :json => films
  end
end
