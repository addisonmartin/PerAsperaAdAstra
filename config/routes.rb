# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # Creates RESTful routes for satellites model.
  resources :satellites

  # Creates the routes for the home controller, whose only action is index.
  get 'home/index'
  # Sets the application's homepage to home's index action.
  root 'home#index'
end
