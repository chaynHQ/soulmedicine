# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  firebase_token
  token
  access_token
  auth_token
  secret_key_base
  secret_token
  secret
  session
  cookie
  csrf
  salt
]
