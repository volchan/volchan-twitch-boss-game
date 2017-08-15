Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  root to: 'pages#home'

  resources :bots, only: %i[destroy show]

  resources :boss_games, only: %i[create update]
end
