Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [:new, :create]
    resource :session, only: [:create, :destroy]
  end
end