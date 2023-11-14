Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :merchants, only: [] do
    resources :dashboard, only: :index, controller: 'merchants', action: 'show'
    resources :items, on: :member, only: [:index, :new, :create, :update, :show, :edit], controller: "merchant_items" 
    resources :invoices, only: [:index, :show], controller: "merchant_invoices"
    resources :bulk_discounts
  end 
  
  patch "/merchants/:merchant_id/invoices/:invoices", to: "merchant_invoice_items#update"

  namespace :admin do
    root "dashboard#index"
    resources :merchants, only: [:index, :create, :new, :show, :update, :edit], controller: "merchants"
    resources :invoices, only: [:index, :update], controller: "invoices"
    get "/invoices/:invoice_id", to: "invoices#show", as: "invoice_show"
  end
end
