Rails.application.routes.draw do

  root 'map#index'

  get 'map/index'
  post 'map/pop_district' => 'map#population_in_districts'

end
