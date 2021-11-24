Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/signup',                   to: 'users#new'
  post   '/signup',                   to: 'users#create'
  get    '/login',                    to: 'sessions#new'
  post   '/login',                    to: 'sessions#create'
  delete '/logout',                   to: 'sessions#destroy'
  patch  '/users/:id/edit',           to: 'users#update'
  get    '/projects/signup',          to: 'projects#new'
  post   '/projects/signup',          to: 'projects#create'
  patch  '/projects/:id/edit',        to: 'projects#update'
  get    '/works/:id/edit',           to: 'works#edit'
  patch  '/works/:id/edit',           to: 'works#update'
  get    '/works/:user_id/:date',     to: 'works#show'
  get    '/works/:user_id/:date/new', to: 'works#new'
  post   '/works/:user_id/:date/new', to: 'works#create'
  delete '/works/:id',                to: 'works#destroy'
  get    '/works/search',             to: 'works#search'
  get    '/holidays/signup',          to: 'holidays#new'
  post   '/holidays/signup',          to: 'holidays#create'
  patch  '/holidays/:id/edit',        to: 'holidays#update'
  resources :users
  resources :projects, except: [:show] do
    collection { post :import }
  end
  resources :holidays, except: [:show] do
    collection { post :import }
  end
end
