Rails.application.routes.draw do
  root to: 'pages#home'
  resources :clinic_trials, only: [:index, :show]
  post "clinic_trials/:id", to: "clinic_trials#register_patient"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    root 'dashboard#index'

    resources :clinic_trials, only: [:index, :create, :update, :show]
    get "clinic_trials/import/:id", to: "clinic_trials#import"
  end 
end
