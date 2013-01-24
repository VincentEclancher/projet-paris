ProjetParis::Application.routes.draw do

  resources :accounts


  devise_for :users

	get '/paris/:sport/bet' => 'bet#show', :as => :bet
	get '/paris/:name' => 'paris#show', :as => :paris
	get '/users/edit' => 'devise#registrations#edit', :as => :edit
	post '/mise' => 'mise#show', :as => :mise
	get '/:user_id/mes_paris' => 'bet_user#show', :as => :bet_user
    get '/' => 'pages#index', :as => :root

end
