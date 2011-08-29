Campus::Application.routes.draw do
  root :to => "homes#show"

  match '/majors' => 'majors#index'''

  resources :courses do
    collection do
      get :school
    end
  end

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

  resources :schools

  resource :requests do
    collection do
      get 'books'
      get 'messages'
    end
  end

end
