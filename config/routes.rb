Rails.application.routes.draw do
  get 'users/update'

	root 'pages#home'
	resources :users # Added to enable form
	match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
	match '/signout', to: 'sessions#destroy', via: [:get, :post]
	match '/auth/failure', to: 'sessions#failure', via: [:get, :post]
end
