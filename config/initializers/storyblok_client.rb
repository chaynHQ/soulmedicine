storyblok_token = ENV.fetch('STORYBLOK_TOKEN') { raise 'STORYBLOK_TOKEN missing' }

STORYBLOK_CLIENT = if ENV['CONTENT_PREVIEW_MODE'] == 'true'
                     Storyblok::Client.new(
                       token: storyblok_token,
                       version: 'draft'
                     )
                   else
                     redis_cache_url = ENV.fetch('REDIS_CACHE_URL') { raise 'REDIS_CACHE_URL missing' }
                     redis = Redis.new url: redis_cache_url

                     ttl = ENV.fetch('CONTENT_CACHE_TTL_MINS', 60).to_i * 60
                     cache = Storyblok::Cache::Redis.new redis: redis, ttl: ttl

                     Storyblok::Client.new(
                       cache: cache,
                       token: storyblok_token,
                       version: 'published'
                     )
                   end
