Campus::Application.routes.draw do

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
  match 'posts/mypost'=>'posts#mypost'
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
    member { post :reserve }
    collection { get :reserved }
  end

  root :to=> "home#show"
end
