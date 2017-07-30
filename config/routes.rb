Rails.application.routes.draw do
	root 'pages#home'
	match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
	match '/signout', to: 'sessions#destroy', via: [:get, :post]
end
