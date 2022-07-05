Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'top#home'

  get  'forecasts',  to: 'forecasts#index'
  #get 'forecasts',  to: 'forecasts#update'

  get  '/api/v1/jma/district/detail', to: 'local_weather_forecast#index'

end
