# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  match '/403', to: 'errors#forbidden', via: :all

  get 'admin/flush_cache', to: 'admin#flush_cache'

  scope '(:locale)', locale: /#{LocalesService.enabled.join("|")}/ do
    resources :subscriptions, only: %i[index]
    get '/unsubscribe/:user_id', controller: :subscriptions, action: :unsubscribe, as: 'subscription_unsubscribe'

    resources :courses, only: %i[index show], path: 'pathways' do
      resources :lessons, only: %i[show], path: 'notes' do
        resource :reaction, only: %i[show update]
      end

      resource :subscription, only: %i[show update destroy] do
        patch :pause
        patch :unpause
      end

      resource :vote, only: %i[create destroy], constraints: { format: :js }
    end

    get  'auth/sign_in'
    post 'auth/callback'
    get  'auth/sign_out'

    resource :profile, only: %i[show update], controller: 'profile'

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
