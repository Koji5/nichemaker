Rails.application.routes.draw do
  root to: "niches#index"
  devise_for :users, controllers: {
    registrations: 'custom_devise/registrations' # カスタムのコントローラーを使用
  }
  get 'user_profile', to: 'custom_devise/registrations#show', as: :user_profile

  resources :niches, path: '/', as: :niche do
    resources :posts
  end

  resources :niche_progress_groups, only: [:create, :destroy, :update] do
    get 'fetch_niche_progress_tasks', on: :member
  end
  
  resources :niche_progress_tasks, only: [:create, :destroy, :update]
  resources :niche_parameters, only: [:create, :destroy, :update]
end
