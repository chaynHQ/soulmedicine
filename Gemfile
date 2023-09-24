# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'

gem 'rails', '~> 7.0', '>= 7.0.8'
gem 'pg', '~> 1.5', '>= 1.5.3'
gem 'puma', '~> 6.3'
gem 'shakapacker', '~> 7.0', '>= 7.0.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'redis', '~> 5.0', '>= 5.0.7'
gem 'storyblok', '~> 3.2'
gem 'shallow_attributes', '~> 0.9.4'
gem 'commonmarker', '~> 0.23'
gem 'twitter_cldr', '~> 4.4', '>= 4.4.3'
gem 'jwt', '~> 2.7', '>= 2.7.1'
gem 'turbolinks', '~> 5.2'
gem 'memoist', '~> 0.16.0'
gem 'bootstrap_form', '~> 4.2'
gem 'sidekiq', '~> 7.1'
gem 'sidekiq-history', '~> 0.0.13'
gem 'rollbar', '~> 2.19', '>= 2.19.3'
gem 'meta-tags', '~> 2.11', '>= 2.11.1'
gem 'active_model_serializers', '~> 0.10.9'
gem 'premailer-rails', '~>1.10.3'
gem 'gemoji'
gem 'truncato', '~> 0.7.12'
gem 'barnes', '~> 0.0.9'
gem 'scout_apm', '~> 5.3', '>= 5.3.5'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.5'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'simplecov', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring', '~> 4.1', '>= 4.1.1'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 1.0'
  gem 'erb_lint', '~> 0.1.3', require: false
end

group :development, :linting do
  gem 'rubocop', '~> 1.28', require: false
  gem 'rubocop-performance', '~> 1.13', require: false
  gem 'rubocop-rails', '~> 2.14', require: false
end

group :development, :security do
  gem 'brakeman', '~> 6.0', '>= 6.0.1'
end

group :test do
  gem 'timecop', '~> 0.9.1'
  gem 'rspec-sidekiq', '~> 3.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
