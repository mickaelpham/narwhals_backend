Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:create]
    resources :transactions, only: [:index]
    get '/transactions/:id/similar', to: 'transactions#similar'
    resource :session, only: [:create, :destroy]
  end
end