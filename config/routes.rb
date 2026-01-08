Rails.application.routes.draw do
  # Devise pour les utilisateurs
  devise_for :users

  # Root path (page d'accueil pour les votants)
  root to: "homes#index"

  # Voter routes
  resources :candidates, only: [:index, :show] do
    member do
      post "vote", to: "candidates#vote"
    end
  end
  resources :votes, only: [:new, :create, :show]
  resources :videos, only: [:index, :show]
  get "emissions/index"

  # Fake payments (testing)
  get  "/ipay/fake/:id",        to: "payments#fake",        as: :ipay_fake_payment
  post "/ipay/fake/confirm/:id", to: "payments#fake_confirm", as: :ipay_fake_confirm
  get "payments/webhook"

  # Admin routes
  namespace :admin do
    root to: "dashboard#index"        # admin_root_path -> /admin
    get "dashboard/index"             # admin_dashboard_index_path

    resources :candidates
    resources :users
    resources :videos
    resources :votes, only: [:index, :destroy]
    resources :results, only: [:index]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
