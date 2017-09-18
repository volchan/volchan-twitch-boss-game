
Rails.application.routes.draw do

  require 'sidekiq/web'

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  devise_for :users
  root to: 'pages#home'

  resources :bots
  resources :bosses, only: :update

  # get :dashboard, to: 'dashboards#index'

  namespace :dashboard do
    root to: 'dashboards#index'
    resources :bots, only: %i[new create edit update delete]
    resources :bosses, only: %i[edit update]
  end
end
