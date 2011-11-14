Memogram::Application.routes.draw do
  ### API ROUTES
  namespace :api, path: 'api/1', format: :json do
    resources :memegrams
  end

  ### WEB ROUTES
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  resources :memegrams, only: [:show]

  root :to => "home#index"
end
