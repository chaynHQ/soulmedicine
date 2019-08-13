# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

host_uri = if ENV.key?('HEROKU_APP_NAME')
             URI("https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com")
           else
             URI(ENV.fetch('SITE_BASE_URL'))
           end

Rails.configuration.host_uri = host_uri

# Initialize the Rails application.
Rails.application.initialize!
