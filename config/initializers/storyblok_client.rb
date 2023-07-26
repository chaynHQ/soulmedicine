storyblok_token = ENV.fetch('STORYBLOK_TOKEN') { raise 'STORYBLOK_TOKEN missing' }

logger = Rails.env.development? ? Rails.logger : nil

given_configuration = {
  api_version: 1, # TODO: Upgrade to API version 2
  token: storyblok_token,
  logger: logger,
  log_level: Rails.logger.level
}

if ENV['CONTENT_PREVIEW_MODE'] != 'true'
  redis_cache_url = ENV.fetch('REDIS_CACHE_URL') { raise 'REDIS_CACHE_URL missing' }
  redis = Redis.new url: redis_cache_url

  ttl = ENV.fetch('CONTENT_CACHE_TTL_MINS', 60).to_i * 60
  cache = Storyblok::Cache::Redis.new redis: redis, ttl: ttl

  given_configuration[:cache] = cache
  given_configuration[:version] = 'published'
end

STORYBLOK_CLIENT = Storyblok::Client.new(given_configuration)
