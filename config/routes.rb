Campus::Application.routes.draw do
  get "class_groups/index"

  get "class_groups/show"

  post "class_groups/create"

  get "class_groups/new"

  get "class_groups/edit"

  get "class_groups/update"

  get "class_groups/destroy"

  get "group/create"
  get "group/mygroup"
  get "lecture/mylecture"
  get "lecture/find_lecture"
 
 
  
  root :to => "homes#show"

  match '/majors' => 'majors#index'''
  match "/home/user_profile/id" =>'homes#user_profile'
  resources :courses do
    collection do
      get :school
    end
  end
 match 'home?' =>"class_group#create"
  match '/users/auth/:provider/callback' => 'authentications#create'  

  devise_for :users,:controllers=> {:sessions => 'sessions', :registrations=> 'registrations' }
  devise_scope :user do
    match '/users/registered' => 'registrations#registered'
  end
resources :courses do
  resources :class_group
    end
 match "/home/user_profile/:id" => 'homes#user_profile', :via=>:get
  resources :books do
    collection { get 'search' }
  end
  
  resources :lecture
  resource :lecture do
    collection do
      get 'mylecture'
      get 'find_lecture'
    end
  end

  resource :group do
    collection do
      get 'create'
      get 'mygroup'
    end
  end
  resources :posts do
    collection do
      get 'latest'
    end
  end

  namespace :setting do
    get "show"
    get "privacy"
    get "notification"
  end

 
  resource :home do
    member do
      get "profile"
      get "welcome"
      get "user_profile"
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
