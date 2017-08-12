Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  
  devise_for :users
  root to: 'pages#home'

  resources 'bots', only: %i[destroy show]
end
