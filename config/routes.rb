Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
      post 'refresh', to: 'auth#refresh'

      get 'profile', to: 'users#profile'

      resources :users, only: [:index, :show, :destroy]
    end
  end
end
