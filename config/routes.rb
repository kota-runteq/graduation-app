Rails.application.routes.draw do
  devise_for :users
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :menus, only: [:index, :show]
  root "top#index"
  resources :chains, only: [ :index, :show ]
end
