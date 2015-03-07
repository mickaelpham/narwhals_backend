Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:create]
    resources :transactions, only: [:index]
    resources :savings, only: [:index, :create, :show, :preview]
    resource :session, only: [:create, :destroy]
    get '/transactions/:id/similar', to: 'transactions#similar'
  end
end
