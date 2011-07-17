Campus::Application.routes.draw do
<<<<<<< HEAD
  get "course/create"

  get "school/create"

=======
  match '/auth/:provider/callback' => 'authentications#create'  
>>>>>>> 239aa36ecbcd9622859598c6b302c0899178c864
  match "landing_page/index", :to => 'landing_page#index'

  devise_for :users,:controllers=> {:registrations=> 'registrations' }

  resources :books
  resources :posts

  namespace :setting do
    get "show"
    get "privacy"
    get "notification"
  end

  namespace :home do
    get "show"
    get "edit"
    get "profile"
    get "welcome"
  end
  

  root :to=> "home#show"
end
