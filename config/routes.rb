Rails.application.routes.draw do
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :packages, only: %i[create show index] do
    resources :notifications, only: %i[create index]
  end
  post 'webhook/:company/:status/:track_id',
       constraints: {
         status: /(delivered|arrived|departed)/,
         company: /(happy_package|fast_delivery)/
       },
       to: 'webhook#create'

  match '*path', via: :all, to: proc { [404, {}, ['not found']] }
end
