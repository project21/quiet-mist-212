Campus::Application.routes.draw do
  get "landing_page/index"
 
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
  
  devise_for :users,:controllers=> {:registrations=> 'registrations' }
  resources :books

  root :to=> "home#show"
end
