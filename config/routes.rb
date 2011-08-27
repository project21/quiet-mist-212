Campus::Application.routes.draw do
  root :to => "homes#show"

  get "request_response/books"

  match '/majors' => 'majors#index'''

  resources :courses do
    collection do
      get :school
    end
  end

  resources :schools

  match '/users/auth/:provider/callback' => 'authentications#create'  
  match 'request_response/books' =>'request_response#books'
  match 'request_response/message' =>'request_response#message'

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

  resource :home do
    member do
      get "profile"
      get "welcome"
    end
  end
  
  resources :book_ownerships do
    member { post :reserve }
    collection { get :reserved }
  end
end
