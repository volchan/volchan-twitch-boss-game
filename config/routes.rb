Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources 'bots'

  get 'start_thread/:id', to: 'bot_threads#start_thread', as: :bot_threads
end
