Rails.application.routes.draw do

  resources :conversations

  get 'conversation/current_conversation'

  get 'articles/matches' =>'articles#matches', :as => "matches_article"
  get 'articles/random' => 'articles#random', :as => "random_article"
  get 'articles/like/:id' => 'articles#like', :as => "like_article"
  #get 'articles/index' => 'articles#index', :as => "index"

  get 'articles/exchangeHandler' =>'articles#exchange_handler', :as => "exchange_handler"

  resources :articles

  # resources :articles do
  #  collection do
  #    get :matches =>'articles#matches', :as => "matches_article"
  #    get :random => 'articles#random', :as => "random_article"
  #  end
  #   member do
  #     get :like/:id => 'articles#like', :as => "like_article"
  #     get :exchangeHandler =>'articles#exchange_handler', :as => "exchange_handler"
  #   end
  # end
  

  #devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # You can have the root of your site routed with "root"
  #root :to =>'user#show'
  #devise_for :users

  #devise_for :users
  devise_scope :user do
  authenticated :user do
    root :to => 'articles#index'
  end
  unauthenticated :user do
    root :to => 'devise/sessions#new', as: :unauthenticated_root
  end
end

   match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
end
