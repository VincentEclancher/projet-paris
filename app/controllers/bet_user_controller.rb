class BetUserController < ApplicationController
before_filter :authenticate_user!
    def show
        @lesParis = BetUser.listParis(params[:user_id])
    end
end