# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, :only => :omniauth_callbacks, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  scope "(:locale)", :locale => /#{I18n.available_locales.join("|")}/ do
    devise_for :users, :path => "auth", :skip => :omniauth_callbacks, :path_names => {
      :sign_in => "login",
      :sign_out => "logout",
      :password => "secret",
      :registration => "register",
      :sign_up => "me"
    }

    get "/:locale" => "pages#landing"
    get "/about" => "pages#about"
    get "/contact" => "pages#contact"

    # Courses
      resources :courses, :controller => 'courses', :only => [:index, :show]
    
    root :to => "pages#landing"
    mount Facebook::Messenger::Server, at: 'bot'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
