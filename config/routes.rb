ProjetParis::Application.routes.draw do

  resources :accounts


  devise_for :users

	get '/paris/:sport/bet' => 'bet#show', :as => :bet
	get '/paris/:name' => 'paris#show', :as => :paris
	get '/users/edit' => 'devise#registrations#edit', :as => :edit
	post '/paris/:sport/mise' => 'mise#show', :as => :mise
    get '/' => 'pages#index', :as => :root

end
