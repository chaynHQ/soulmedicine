# frozen_string_literal: true

Rails.application.routes.draw do
  resources :courses, only: %i[index show], path: 'pathways' do
    resources :lessons, only: %i[show], path: 'steps'
  end

  root to: 'pages#landing'
end
