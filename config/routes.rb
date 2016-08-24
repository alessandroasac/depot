Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :orders
  resources :carts

  get 'store/index'

  resources :line_items do
    member do
      post 'decrement'
    end
  end

  resources :products do
    get :who_bought, on: :member
  end

  root 'store#index', as: 'store'

end
