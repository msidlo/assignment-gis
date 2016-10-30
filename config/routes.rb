Rails.application.routes.draw do

  root 'map#index'

  get 'map/index'
  post 'map' => 'map#tn'

end
