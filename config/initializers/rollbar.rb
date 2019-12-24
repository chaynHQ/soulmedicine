RollbarConfig = OpenStruct.new

RollbarConfig.server_access_token = ENV['SERVER_ROLLBAR_ACCESS_TOKEN']
RollbarConfig.client_access_token = ENV['CLIENT_ROLLBAR_ACCESS_TOKEN']
RollbarConfig.environment = (PullRequestNumber.call || ENV.fetch('ROLLBAR_ENV'))

Rollbar.configure do |config|
  config.access_token = RollbarConfig.server_access_token
  config.enabled = false if Rails.env.test? || Rails.env.development?
  config.environment = RollbarConfig.environment if config.enabled
  config.exception_level_filters.merge!('ActionController::UnknownFormat' => 'warning')
end
