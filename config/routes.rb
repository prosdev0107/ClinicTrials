Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    root 'dashboard#index'

    resources :clinic_trials, only: [:index, :create, :update]
    get "clinic_trials", "clinic_trials/import"
  end 
end
