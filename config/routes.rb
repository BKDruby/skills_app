Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: [:new, :edit] do
        collection do
          get "/:field/:value", to: "users#show"
        end
      end
      post "/sign_in", to: "auth#sign_in"
    end
  end

  resources :api_docs, only: [:index]

  root to: "api_docs#index"
end
