# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bindings to the Duktape JavaScript interpreter (https://github.com/judofyr/duktape.rb)
gem 'duktape'
# Create JSON structures via a Builder-style DSL (https://github.com/rails/jbuilder)
gem 'jbuilder', '~> 2.5'
# Pg is the Ruby interface to the {PostgreSQL RDBMS}[http://www.postgresql.org/] (https://bitbucket.org/ged/ruby-pg)
gem 'pg', '>= 0.18', '< 2.0'
# Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications (http://puma.io)
gem 'puma', '~> 3.11'
# Full-stack web application framework. (http://rubyonrails.org)
gem 'rails', '~> 5.2'
# Sass adapter for the Rails asset pipeline. (https://github.com/rails/sass-rails)
gem 'sass-rails', '~> 5.0'
# Turbolinks makes navigating your web application faster (https://github.com/turbolinks/turbolinks)
gem 'turbolinks', '~> 5'
# Ruby wrapper for UglifyJS JavaScript compressor (http://github.com/lautis/uglifier)
gem 'uglifier', '>= 1.3.0'
# Use webpack to manage app-like JavaScript modules in Rails (https://github.com/rails/webpacker)
gem 'webpacker'
# gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password

# gem 'mini_magick', '~> 4.8' # Use ActiveStorage variant

# gem 'capistrano-rails', group: :development # Use Capistrano for deployment

# Boot large ruby/rails apps faster (https://github.com/Shopify/bootsnap)
gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb

# SM Gems
# Use jQuery with Rails 4+ (https://github.com/rails/jquery-rails)
gem 'jquery-rails'
# XML serialization for your Active Model objects and Active Record models - extracted from Rails (http://github.com/rails/activemodel-serializers-xml)
gem 'activemodel-serializers-xml'
# Flexible authentication solution for Rails with Warden (https://github.com/plataformatec/devise)
gem 'devise'
# Translations for the devise gem (http://github.com/tigrish/devise-i18n)
gem 'devise-i18n'
# Rails I18n de-facto standard library for ActiveRecord model/data translation (http://github.com/globalize/globalize)
gem 'globalize', github: 'globalize/globalize'
# Normalize.css is a customisable CSS file that makes browsers render all elements more consistently and in line with modern standards. We researched the differences between default browser styles in order to precisely target only the styles that need normalizing. (https://github.com/markmcconachie/normalize-rails)
gem 'normalize-rails'
# Facebook OAuth2 Strategy for OmniAuth (https://github.com/mkdynamic/omniauth-facebook)
gem 'omniauth-facebook'
# Automatic Ruby code style checking tool. (https://github.com/rubocop-hq/rubocop)
gem 'rubocop', require: false
# Forms made easy! (https://github.com/plataformatec/simple_form)
gem 'simple_form'
# MarcoPolo shows your app name and environment in your console prompt (http://github.com/arches/marco-polo)
gem 'marco-polo'
# gem that enables easier nested forms with standard forms, formtastic and simple-form (http://github.com/nathanvda/cocoon)
gem "cocoon"
# Collection of SEO helpers for Ruby on Rails. (http://github.com/kpumuk/meta-tags)
gem 'meta-tags'
# Facebook Messenger client (https://github.com/hyperoslo/facebook-messenger)
gem 'facebook-messenger'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  # A debugging tool for your Ruby on Rails applications. (https://github.com/rails/web-console)
  gem 'web-console', '>= 3.3.0'
  # Better error page for Rails and other Rack apps (https://github.com/charliesome/better_errors)
  gem 'better_errors'
  # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack. (http://github.com/banister/binding_of_caller)
  gem 'binding_of_caller'
end

group :development, :test do
  # Ruby fast debugger - base + CLI (http://github.com/deivid-rodriguez/byebug)
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # Autoload dotenv in Rails. (https://github.com/bkeepers/dotenv)
  gem 'dotenv-rails'
  # RSpec for Rails (https://github.com/rspec/rspec-rails)
  gem 'rspec-rails', '~> 3.7'
end

group :development, :staging do
  # Profiles loading speed for rack applications. (http://miniprofiler.com)
  gem 'rack-mini-profiler'
end

group :test do
  # Capybara aims to simplify the process of integration testing Rack applications, such as Rails, Sinatra or Merb (https://github.com/teamcapybara/capybara)
  gem 'capybara', '>= 2.15', '< 4.0'
  # Easy installation and use of chromedriver. (https://github.com/flavorjones/chromedriver-helper)
  gem 'chromedriver-helper'
  # The next generation developer focused tool for automated testing of webapps (https://github.com/SeleniumHQ/selenium)
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Timezone Data for TZInfo (http://tzinfo.github.io)
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
