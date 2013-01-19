ProjetParis::Application.routes.draw do

  resources :accounts


  devise_for :users

	get '/paris/:sport/bet' => 'bet#show', :as => :bet
	get '/paris/:name' => 'paris#show', :as => :paris
    get '/' => 'pages#index', :as => :root

end
