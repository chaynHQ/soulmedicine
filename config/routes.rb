# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{LocalesService.enabled.join("|")}/ do
    resources :courses, only: %i[index show], path: 'pathways' do
      resources :lessons, only: %i[show], path: 'steps'
    end
    get 'auth/log_in'
    get 'auth/callback'
    get 'auth/logout'

    root to: 'pages#landing'
  end
end
