Rails.application.routes.draw do
  root to: "niches#index"
  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations' # カスタムのコントローラーを使用
  }
  resources :niches, path: '/', as: :niche do
    resources :posts
  end

  get 'user_profile', to: 'custom_devise/registrations#show', as: :user_profile
  resources :niche_progress_groups, only: [:create, :destroy, :update] do
    get 'fetch_niche_progress_tasks', on: :member
  end
end
