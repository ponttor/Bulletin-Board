# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    resource :profile, only: :show
    resource :session, only: :destroy

    resources :bulletins, except: :index do
      member do
        patch 'archive'
        patch 'moderate'
      end
    end

    namespace :admin do
      root 'home#index'
      resources :categories, except: :show
      resources :bulletins, only: :index do
        member do
          patch 'archive'
          patch 'publish'
          patch 'reject'
        end
      end
    end

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  end
end
