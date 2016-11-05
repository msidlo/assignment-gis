Rails.application.routes.draw do

  root 'map#index'

  get 'map/index'
  post 'map/pop_district' => 'map#population_in_districts'
  post 'map/wage_in_regions' => 'map#wage_in_regions'

end
