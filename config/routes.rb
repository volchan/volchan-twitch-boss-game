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
  get :sub_goal, to: 'goals#show_sub_goal'
  get :bits_goal, to: 'goals#show_bits_goal'

  namespace :dashboard do
    root to: 'dashboards#show'
    resources :bots, only: %i[new create edit update destroy]
    resources :bosses, only: %i[edit update]
    resources :bots_status, only: :index
    resources :subscriptions, only: %i[new create]
    resources :goals, only: %i[create edit update destroy]
    patch 'goals/:id/pause', to: 'goals#pause', as: :pause_goal
    get 'goals/new/sub_goal', to: 'goals#new_sub_goal'
    get 'goals/new/bits_goal', to: 'goals#new_bits_goal'
  end
end
