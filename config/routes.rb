Campus::Application.routes.draw do

  match '/majors' => 'majors#index'''

  resources :courses do
    collection do
      get :school
    end
  end

  resources :schools

  match '/users/auth/:provider/callback' => 'authentications#create'  

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
