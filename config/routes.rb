Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  root to: 'pages#home'

  resources :bots, only: %i[index show destroy]

  get :create_boss, to: 'boss_games#create_boss'
  get 'update_boss/:id', to: 'boss_games#update_boss'
  get 'update_current_hp/:id', to: 'boss_games#update_current_hp'
  get 'update_shield/:id', to: 'boss_games#update_shield'
end
