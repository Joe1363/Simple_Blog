Rails.application.routes.draw do
  root "articles#index"
  resources :comments

  get "articles/all"
  resources :articles

  devise_for :users, :controllers => { registrations: 'registrations' }
  get 'users/tools'
  patch 'users/tools/:id', to: 'users#toggleMod'
  get "users/:id", to: "users#show"
end
