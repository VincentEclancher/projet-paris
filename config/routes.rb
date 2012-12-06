ProjetParis::Application.routes.draw do

	get 'paris/football' => 'paris_foot#get_paris_foot', :as => :paris_foot
	get 'paris/tennis' => 'paris#get_paris', :as => :paris

    get '' => 'pages#index', :as => :root

end
