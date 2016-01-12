Rails.application.routes.draw do
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

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
