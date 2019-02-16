# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'rails', '~> 5.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'webpacker', '~> 3.5', '>= 3.5.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'redis', '~> 4.0', '>= 4.0.3'
gem 'storyblok', '~> 2.0'
gem 'shallow_attributes', '~> 0.9.4'
gem 'commonmarker', '~> 0.18.2'
gem 'twitter_cldr', '~> 4.4', '>= 4.4.3'
gem 'jwt', '~> 2.1.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.5'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.1'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors', '~> 2.5'
  gem 'binding_of_caller', '~> 0.8.0'
  gem 'rubocop', '~> 0.62.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
