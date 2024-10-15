Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: proc { [404, {}, ["Not found."]] }

  namespace :api do
    namespace :v1 do
      # restaurants
      resources :restaurants, only: [:index, :show]
        post    'restaurants', to: 'restaurants#create_or_update'
        delete  'restaurants', to: 'restaurants#destroy'

      # menus
      resources :menus, only: [:index, :show]
      post    'menus', to: 'menus#create_or_update'
      delete  'menus', to: 'menus#destroy'
    end
  end
end
