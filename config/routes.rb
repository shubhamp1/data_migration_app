Rails.application.routes.draw do

  devise_for :users

  resources :patients, only: %i[index show] do
    collection do
      post :upload_csv
    end
  end

  resources :migration_histories, only: %i[index show]

  root 'patients#index'
end
