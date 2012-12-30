ProjetParis::Application.routes.draw do

	get '/paris/:name' => 'paris#show', :as => :paris
    get '' => 'pages#index', :as => :root

end
