Rails.application.routes.draw do
  root to: 'commands#index'
  resources :commands, param: :uuid, only: [:index, :show, :create, :destroy]
end
