Rails.application.routes.draw do

  get 'articles/matches' =>'articles#matches', :as => "matches_article"
  get 'articles/random' => 'articles#random', :as => "random_article"
  get 'articles/like/:id' => 'articles#like', :as => "like_article"
  post 'articles/:id/edit' => 'articles#edit', :as => "edit_article"
  get 'articles/exchangeHandler' =>'articles#exchange_handler', :as => "exchange_handler"
  get 'articles/delete_exchange' =>'articles#delete_exchange', :as => "delete_exchange"

  resources :articles

  resources :articles do
   collection do
     get :matches
     get :random
   end
    member do
      get :like
      get :exchangeHandler
      post :edit
      get :delete_match
    end
  end

  post 'conversations/new_message' =>'conversations#new_message'
  get 'conversation/current_conversation'

  resources :conversations

  resources :conversations do
   collection do
   end
    member do
      post :new_message
      get :current_conversation
    end
  end

  devise_for :users, :controllers => { registrations: 'users/registrations' }

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
