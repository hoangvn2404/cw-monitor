require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :warrants do
    member do
      get :toggle_watch_list

    end
    collection do
      get :watch_list
    end
  end
  root to: "warrants#index"
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
