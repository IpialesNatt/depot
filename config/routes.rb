Rails.application.routes.draw do
  get "admin" => "admin#index"

  resources :users
  resource :session                         # login/logout como recurso único
  resources :passwords, param: :token       # para recuperar contraseña, si lo usas
  resources :orders

  resources :line_items do
    member do
      patch :decrement                      # si tienes la función "decrementar"
    end
  end

  resources :carts

  resources :products do
    member do
      get :who_bought                       # si implementaste ese feature
    end
  end

  root "store#index", as: "store_index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
 
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
