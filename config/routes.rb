Rails.application.routes.draw do
  namespace :auth do
      post "login", to: "authentication#login"
      post "signup", to: "authentication#signup"
      get "token_validate", to: "authentication#token_validate"
  end
end
