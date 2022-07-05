Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'top#home'

  get  'forecasts', to: 'forecasts#index'
  #get 'forecasts', to: 'forecasts#update'

  get  '/api/v1/forecasts', to: 'forecasts#index'
  get  '/api/v1/forecasts/:service', to: 'forecasts#show'

end
