# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{LocalesService.enabled.join("|")}/ do
    resources :subscriptions, only: [:index]

    resources :courses, only: %i[index show], path: 'pathways' do
      resources :lessons, only: %i[show], path: 'notes'

      resource :subscription, only: %i[show update destroy] do
        patch :pause
        patch :unpause
        get '/unsubscribe/:user_id', action: :unsubscribe, as: 'unsubscribe'
      end
    end

    get  'auth/sign_in'
    post 'auth/callback'
    post 'auth/accept_policy'
    get  'auth/sign_out'

    resources :subscriptions, only: %i[index]

    resources :pages, only: %i[show]
    root to: 'pages#landing'
  end

  mount Sidekiq::Web => '/sidekiq'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Ref: https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
    expected_username, expected_password = ENV.fetch('ADMIN_BASIC_AUTH').split(':')
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(expected_username)) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(expected_password))
  end
end
