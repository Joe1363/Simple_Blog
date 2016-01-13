Rails.application.routes.draw do
  root "articles#index"
  resources :comments

  get "articles/:id/share", to: "articles#fb_share"
  get "articles/all"
  get "articles/search"
  resources :articles
  match('/articles/:id/create', {:via => :post, :to => 'comments#create'})

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => "users/omniauth_callbacks" }
  get 'users/tools'
  patch 'users/tools/:id', to: 'users#toggleMod'
  get "users/:id", to: "users#show"
end
