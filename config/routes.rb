Rails.application.routes.draw do
  root "pages#home"
  post "/", to: "pages#home"
  get "/analytics", to: "analytics#index"

  # session pages
  get "/auth", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # error pages
  %w[404 422 500].each do |code|
    match code, to: "exceptions#show", code: code, via: :all
  end

  # catch all other paths and redirect them to home
  get "*path", to: "pages#redirect"
end
