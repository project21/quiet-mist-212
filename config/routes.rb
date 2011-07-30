Campus::Application.routes.draw do

  resources :courses

  get "school/create"


  match '/users/auth/:provider/callback' => 'authentications#create'  

  match "landing_page/index", :to => 'landing_page#index'

  devise_for :users,:controllers=> {:registrations=> 'registrations' }
  devise_scope :user do
    match '/users/registered' => 'registrations#registered'
  end

  resources :books do
    collection { get 'search' }
  end

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
  
  resources :book_ownerships do
  end

  root :to=> "home#show"
end
