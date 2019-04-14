# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{LocalesService.enabled.join("|")}/ do
    resources :courses, only: %i[index show], path: 'pathways' do
      resources :lessons, only: %i[show], path: 'steps'
    end

    get  'auth/sign_in'
    post 'auth/callback'
    post 'auth/accept_policy'
    get  'auth/sign_out'

    resources :subscriptions, only: %i[index]

    root to: 'pages#landing'
  end
end
