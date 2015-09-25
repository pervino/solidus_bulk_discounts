Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :bulk_discounts
  end
end