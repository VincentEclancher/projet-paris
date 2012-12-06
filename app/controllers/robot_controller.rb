class RobotController < ApplicationController
  def index
    matchs = Robot.last_matchs
    render :json => matchs
  end
end
