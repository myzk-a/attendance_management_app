Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/signup',                 to: 'users#new'
  post   '/signup',                 to: 'users#create'
  get    '/login',                  to: 'sessions#new'
  post   '/login',                  to: 'sessions#create'
  delete '/logout',                 to: 'sessions#destroy'
  patch  '/users/:id/edit',         to: 'users#update'
  get    '/projects/signup',        to: 'projects#new'
  post   '/projects/signup',        to: 'projects#create'
  patch  '/projects/:id/edit',      to: 'projects#update'
  get    '/days/:user_id/:day/new', to: 'days#new'
  get    '/days/:user_id/:day',     to: 'days#show'
  resources :users
  resources :projects, except: [:show]
end
