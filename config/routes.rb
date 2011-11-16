Memegram::Application.routes.draw do
  ### API ROUTES
  namespace :api, path: 'api/1', format: :json do
    resources :memegrams
  end

  ### WEB ROUTES
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  # custom oauth controller mapping
  match '/auth/instagram/callback' => 'oauth#instagram_callback'
  resources :memegrams, only: [:show]

  root :to => "home#index"
end
