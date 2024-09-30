# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  resources :patients, only: %i[index show] do
    collection do
      post :upload_csv
    end
  end

  resources :migration_histories, only: %i[index show]

  root 'patients#index'
end
