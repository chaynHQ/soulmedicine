Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.enabled = false if Rails.env.test? || Rails.env.development?
  config.environment = (PullRequestNumber.call || ENV.fetch('ROLLBAR_ENV')) if config.enabled
  config.exception_level_filters.merge!('ActionController::UnknownFormat' => 'warning')
end
