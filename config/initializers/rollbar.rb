RollbarConfig = OpenStruct.new

RollbarConfig.enabled = !(Rails.env.test? || Rails.env.development?)
RollbarConfig.server_access_token = ENV['SERVER_ROLLBAR_ACCESS_TOKEN']
RollbarConfig.client_access_token = ENV['CLIENT_ROLLBAR_ACCESS_TOKEN']
RollbarConfig.environment = (PullRequestNumber.call || ENV.fetch('ROLLBAR_ENV')) if RollbarConfig.enabled

Rollbar.configure do |config|
  config.access_token = RollbarConfig.server_access_token
  config.async_json_payload = true
  config.enabled = RollbarConfig.enabled
  config.environment = RollbarConfig.environment if config.enabled
  config.exception_level_filters['ActionController::UnknownFormat'] = 'warning'
  config.use_sidekiq
end
