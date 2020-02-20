# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # Creates RESTful routes for satellites model.
  # Only includes the show and index action, because the data comes from an outside source and should not be user modifiable.
  resources :satellites, only: [:show, :index]

  # Creates the routes for the home controller, whose only action is index.
  get 'home/index'
  # Sets the application's homepage.
  root 'satellites#index'
end
