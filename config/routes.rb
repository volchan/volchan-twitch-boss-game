Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, ->(u) { u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root to: 'pages#home'

  resources :bots, only: :show
  resources :bosses, only: :update

  namespace :dashboard do
    root to: 'dashboards#show'
    resources :bots, only: %i[new create edit update destroy]
    resources :bosses, only: %i[edit update]
    resources :bots_status, only: :index
  end

  resources :subscriptions, only: %i[new create], path: 'subscription'

  namespace :profile do
    root to: 'profiles#show'
  end
end
