Rails.application.routes.draw do
  resources :items
  resources :categories
  resources :retailers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
