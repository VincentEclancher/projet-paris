class MiseController < ApplicationController
  
  def show
    puts '----------------------------------'
    puts 'IN MISE CONTROLLER !'
    puts '>>>>>> Mise = ' + params[:mise]
    puts '>>>>>> Bet id = ' + params[:user_id]
    puts '----------------------------------'
    @resultatMise = Mise.controleMise(params[:mise], params[:user_id], params[:bet_id])

    puts '----------------------------------'
    puts 'IN BET CONTROLLER RESULTAT !'
    puts '>>>>>> Retour mise ' + @resultatMise.to_s
    puts '----------------------------------'
  end
end