# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

gem 'rails', '~> 5.2.4.2'
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
gem 'truncato', '~> 0.7.12'

group :development, :test do
  gem 'byebug', '~> 11.1', '>= 11.1.3', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.3'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'simplecov', '~> 0.22.0', require: false
end

group :development do
  gem 'web-console', '~> 3.7'
  gem 'listen', '~> 3.8'
  gem 'spring', '~> 4.1', '>= 4.1.1'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'better_errors', '~> 2.10', '>= 2.10.1'
  gem 'binding_of_caller', '~> 1.0'
  gem 'rubocop', '~> 1.55', require: false
  gem 'rubocop-performance', '~> 1.18', require: false
  gem 'rubocop-rails', '~> 2.20', '>= 2.20.2', require: false
  gem 'erb_lint', '~> 0.1.3', require: false
  gem 'brakeman', '~> 5.4', '>= 5.4.1'
end

group :test do
  gem 'timecop', '~> 0.9.6'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
