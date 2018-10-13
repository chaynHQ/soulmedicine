# frozen_string_literal: true

# == Route Map
#
#                           Prefix Verb     URI Pattern                                                                              Controller#Action
# user_facebook_omniauth_authorize GET|POST /users/auth/facebook(.:format)                                                           users/omniauth_callbacks#passthru
#  user_facebook_omniauth_callback GET|POST /users/auth/facebook/callback(.:format)                                                  users/omniauth_callbacks#facebook
#                 new_user_session GET      (/:locale)/auth/login(.:format)                                                          devise/sessions#new {:locale=>/en|ur|ar/}
#                     user_session POST     (/:locale)/auth/login(.:format)                                                          devise/sessions#create {:locale=>/en|ur|ar/}
#             destroy_user_session DELETE   (/:locale)/auth/logout(.:format)                                                         devise/sessions#destroy {:locale=>/en|ur|ar/}
#                new_user_password GET      (/:locale)/auth/secret/new(.:format)                                                     devise/passwords#new {:locale=>/en|ur|ar/}
#               edit_user_password GET      (/:locale)/auth/secret/edit(.:format)                                                    devise/passwords#edit {:locale=>/en|ur|ar/}
#                    user_password PATCH    (/:locale)/auth/secret(.:format)                                                         devise/passwords#update {:locale=>/en|ur|ar/}
#                                  PUT      (/:locale)/auth/secret(.:format)                                                         devise/passwords#update {:locale=>/en|ur|ar/}
#                                  POST     (/:locale)/auth/secret(.:format)                                                         devise/passwords#create {:locale=>/en|ur|ar/}
#         cancel_user_registration GET      (/:locale)/auth/register/cancel(.:format)                                                devise/registrations#cancel {:locale=>/en|ur|ar/}
#            new_user_registration GET      (/:locale)/auth/register/me(.:format)                                                    devise/registrations#new {:locale=>/en|ur|ar/}
#           edit_user_registration GET      (/:locale)/auth/register/edit(.:format)                                                  devise/registrations#edit {:locale=>/en|ur|ar/}
#                user_registration PATCH    (/:locale)/auth/register(.:format)                                                       devise/registrations#update {:locale=>/en|ur|ar/}
#                                  PUT      (/:locale)/auth/register(.:format)                                                       devise/registrations#update {:locale=>/en|ur|ar/}
#                                  DELETE   (/:locale)/auth/register(.:format)                                                       devise/registrations#destroy {:locale=>/en|ur|ar/}
#                                  POST     (/:locale)/auth/register(.:format)                                                       devise/registrations#create {:locale=>/en|ur|ar/}
#                                  GET      (/:locale)/:locale(.:format)                                                             pages#landing {:locale=>/en|ur|ar/}
#                            about GET      (/:locale)/about(.:format)                                                               pages#about {:locale=>/en|ur|ar/}
#                          contact GET      (/:locale)/contact(.:format)                                                             pages#contact {:locale=>/en|ur|ar/}
#                          courses GET      (/:locale)/courses(.:format)                                                             courses#index {:locale=>/en|ur|ar/}
#                           course GET      (/:locale)/courses/:id(.:format)                                                         courses#show {:locale=>/en|ur|ar/}
#                             root GET      /(:locale)(.:format)                                                                     pages#landing {:locale=>/en|ur|ar/}
#        facebook_messenger_server          (/:locale)/bot                                                                           Facebook::Messenger::Server {:locale=>/en|ur|ar/}
#               rails_service_blob GET      /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#        rails_blob_representation GET      /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#               rails_disk_service GET      /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#        update_rails_disk_service PUT      /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#             rails_direct_uploads POST     /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

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
