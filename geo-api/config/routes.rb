Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :geo_locations, only: [:show, :create, :destroy, :index]
end
