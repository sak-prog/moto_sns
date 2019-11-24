Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  root to: 'home#index'
  get 'about', to: 'home#about'
  get 'index', to: 'home#index'
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"}
  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: %i[index show new create destroy] do
    resources :likes, only: %i[create destroy]
    resources :comments, only: %i[create destroy], shallow: true
  end
  resources :relationships, only: %i[create destroy]
end
