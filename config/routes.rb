Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'welcome#index'

  get '/register', to: 'users#new', as: :new_user

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  
  namespace :admin do
    get '/dashboard', to: 'users#index'
    get '/users/:id', to: 'users#show'
  end
  
  get '/dashboard', to: 'users#show'
  get '/discover', to: 'users/discover#index'
  resources :movies, only: [:index, :show], controller: 'users/movies' do
    resources :viewing_party, only: [:new, :create], controller: 'users/movies/viewing_parties'
  end
  resources :users, only: [:create]
end
