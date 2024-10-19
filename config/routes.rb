Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root to: proc { [404, {}, ["Not found."]] }

  namespace :api do
    namespace :v1 do
      # restaurants
      resources :restaurants, only: [:index, :show]
        post    'restaurants',        to: 'restaurants#create_or_update'
        delete  'restaurants',        to: 'restaurants#destroy'
        post   'restaurants/upload',  to: 'restaurants#upload'

      # menus
      resources :menus, only: [:index, :show]
      post    'menus', to: 'menus#create_or_update'
      delete  'menus', to: 'menus#destroy'

      # menu items
      resources :menu_items, only: [:index, :show]
      delete  'menu_items', to: 'menu_items#destroy'

      # items
      resources :items, only: [:index, :show]
      post    'items', to: 'items#create_or_update'
      delete  'items', to: 'items#destroy'
    end
  end
end
