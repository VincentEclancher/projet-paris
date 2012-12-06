ProjetParis::Application.routes.draw do

	get 'paris/football' => 'paris#get_paris_foot', :as => :paris_foot

    get '' => 'pages#index', :as => :root

end
