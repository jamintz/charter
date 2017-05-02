Rails.application.routes.draw do

  get 'clients/index'

  get 'transactions' => 'transactions#index'
  get 'connectors' => 'connectors#index'
  get 'attrs' => 'attrs#index'
  
  resources :clients do
    member do
      get 'show'
    end
  end
  
  post '/clients/add_trx'
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'clients#index'


end
