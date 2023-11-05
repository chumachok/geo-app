Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "geo_locations" => 'geo_locations#create', as: :geo_locations_create
  delete "geo_locations/:lookup_value" => 'geo_locations#destroy', as: :geo_locations_destroy
  get "geo_locations/:lookup_value" => 'geo_locations#show', as: :geo_locations_show
  resources :geo_locations, only: [:index]
end
