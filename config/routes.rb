# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  resources :allocations
  resources :purchases
  resources :items
  resources :categories
  resources :retailers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
