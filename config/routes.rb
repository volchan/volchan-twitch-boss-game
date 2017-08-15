Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  root to: 'pages#home'

  resources :bots, only: %i[destroy show]

  get :create_boss, to: 'boss_games#create_boss'
  get :update_boss, to: 'boss_games#update_boss'
end
