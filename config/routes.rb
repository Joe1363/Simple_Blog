Rails.application.routes.draw do
  root "articles#index"
  resources :comments
  resources :articles

  get "users/user_articles"
  devise_for :users, :controllers => { registrations: 'registrations' }
end
