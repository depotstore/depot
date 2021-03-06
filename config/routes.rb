Rails.application.routes.draw do

  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users do
    post 'edit', on: :member
    post 'pdf', on: :collection
  end

  resources :products do
    get 'who_bought', on: :member
    resources :reviews
  end

  scope '(:locale)' do
    resources :orders do
      post 'ship', on: :member
    end
    resources :line_items do
      post 'decrement', on: :member
    end
    resources :carts
    root 'store#index', as: 'store_index', via: :all

  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
