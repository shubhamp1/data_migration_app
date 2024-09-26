Rails.application.routes.draw do

  devise_for :users

  resources :patients, only: [:index, :upload] do
    collection do
      post :upload_csv
    end
    
  end
  root 'patients#index'
end
