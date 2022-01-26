Rails.application.routes.draw do
  root "pages#home"
  post "/", to: "pages#home"
end
