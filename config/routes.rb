Rails.application.routes.draw do
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  root "articles#index"
  resources :comments

  get "articles/all"
  get "articles/search"
  resources :articles
  match('/articles/:id/create', {:via => :post, :to => 'comments#create'})

  devise_for :users, :controllers => { registrations: 'registrations' }
  get 'users/tools'
  patch 'users/tools/:id', to: 'users#toggleMod'
  get "users/:id", to: "users#show"
end
