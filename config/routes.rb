Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations' # カスタムのコントローラーを使用
  }
  resources :niches do
    resources :posts
  end
  # カスタムの show アクションへのルーティング
  get 'user_profile', to: 'custom_devise/registrations#show', as: :user_profile
end
