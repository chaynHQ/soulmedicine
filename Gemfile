# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

gem 'rails', '~> 6.0.3.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'webpacker', '~> 5.0.1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'redis', '~> 4.1', '>= 4.1.0'
gem 'storyblok', '~> 2.0.5'
gem 'shallow_attributes', '~> 0.9.4'
gem 'commonmarker', '~> 0.20'
gem 'twitter_cldr', '~> 4.4', '>= 4.4.3'
gem 'jwt', '~> 2.1.0'
gem 'turbolinks', '~> 5.2'
gem 'memoist', '~> 0.16.0'
gem 'http', '~> 4.1'
gem 'default_value_for', '~> 3.1'
gem 'bootstrap_form', '~> 4.2'
gem 'sidekiq', '~> 5.2', '>= 5.2.5'
gem 'sidekiq-history', '~> 0.0.11'
gem 'rollbar', '~> 2.19', '>= 2.19.3'
gem 'meta-tags', '~> 2.11', '>= 2.11.1'
gem 'active_model_serializers', '~> 0.10.9'
gem 'premailer-rails', '~>1.10.3'
gem 'gemoji'
gem 'truncato'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.5'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'simplecov', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'rubocop', '~> 0.75.0', require: false
  gem 'rubocop-performance', '~> 1.5', require: false
  gem 'rubocop-rails', '~> 2.2', require: false
  gem 'brakeman'
end

group :test do
  gem 'timecop', '~> 0.9.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
