Rails.application.routes.draw do
  get "temoignages/index"
  get "partenaires/index"
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
  resources :emissions, only: [:index]
  resources :partenaires, only: [:index, :show]
  resources :temoignages, only: [:index, :show]

  # public questions (submit when logged in)
  resources :questions, only: [:new, :create]

  #get "emissions/index"

  # Fake payments (testing)
  get  "/ipay/fake/:id",        to: "payments#fake",        as: :ipay_fake_payment
  post "/ipay/fake/confirm/:id", to: "payments#fake_confirm", as: :ipay_fake_confirm
  get "payments/webhook"

  # Admin routes
  namespace :admin do
    get "temoignages/index"
    root to: "dashboard#index"        # admin_root_path -> /admin
    get "dashboard/index"             # admin_dashboard_index_path

    resources :candidates
    resources :partenaires
    resources :users
    resources :videos
    resources :votes, only: [:index, :destroy]
    resources :results, only: [:index]
    resources :temoignages
    resources :questions
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
