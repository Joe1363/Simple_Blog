Rails.application.routes.draw do
  root "articles#index"
  resources :comments

  get "articles/all"
  resources :articles

  get "users/:id", to: "users#show"
  devise_for :users, :controllers => { registrations: 'registrations' }
end
