Rails.application.routes.draw do
  root "pages#home"
  post "/", to: "pages#home"

  # session pages
  get "/auth", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
