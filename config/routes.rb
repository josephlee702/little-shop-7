Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/invoices", to: "merchant_invoices#index"
  get "/merchants/:merchant_id/items/:item_id", to: "merchant_items#show"
  get "/merchants/:merchant_id/items/:item_id/edit", to: "merchant_items#edit"
  patch "/merchants/:merchant_id/items/:item_id", to: "merchant_items#update"
  get "/merchants/:merchant_id/invoices/:invoices", to: "merchant_invoices#show"

  namespace :admin do
    get "/", to: "dashboard#index"
    get "/merchants", to: "merchants#index"
    get "/merchants/:merchant_id", to: "merchants#show"
    patch "/merchants/:merchant_id", to: "merchants#update"
    get "/merchants/:merchant_id/edit", to: "merchants#edit"

    get "/invoices", to: "invoices#index"
  end

end
