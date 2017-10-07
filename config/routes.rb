Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  devise_for :users
  root to: 'pages#home'
  get ':page', to: 'pages#show'


  resources :bots, only: :show
  resources :bosses, only: :update

  namespace :dashboard do
    root to: 'dashboards#index'
    resources :bots, only: %i[new create edit update destroy]
    resources :bosses, only: %i[edit update]
    resources :bots_status, only: :index
  end
end
