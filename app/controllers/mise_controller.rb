class MiseController < ApplicationController
  before_filter :authenticate_user!

  @resultatMise = Mise.controleMise(params[:mise], params[:user_id])
end