Campus::Application.routes.draw do
  namespace :setting do
    get "show"
    get "privacy"
    get "notification"
  end

  namespace :home do
    get "index"
    get "edit"
    get "show"
    get "welcome"
  end
  
  devise_for :users,:controllers=> {:registrations=> 'registrations' }
  resources :books

      
  root :to=> "home#index"
end
