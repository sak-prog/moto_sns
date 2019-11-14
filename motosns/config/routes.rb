Rails.application.routes.draw do
  root to: 'home#index'
  get 'about', to: 'home#about'
  get 'index', to: 'home#index'
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"}
  resources :users, only: %i[index show]
end
