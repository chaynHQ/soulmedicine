class StoryblokService
  class CmsAccessError < StandardError; end

  class NotFound < StandardError
    attr_reader :path, :type, :id

    def initialize(message = nil, path: nil, type: nil, id: nil)
      @path = path
      @type = type
      @id = id
      super(message)
    end
  end

  attr_reader :client

  def initialize(storyblok_client)
    @client = storyblok_client
  end

  def fetch(path)
  @client.story path, cache_version: latest_cache_version
  rescue RestClient::NotFound
    raise NotFound.new path: path
  rescue RestClient::RequestFailed => e
    Rails.logger.error "[#{self.class.name}] Failed to fetch path '#{path}' from Storyblok – exception: #{e.inspect}"

    raise CmsAccessError
  end

  def fetch_all(path)
  @client.stories({ :starts_with => path })
  rescue RestClient::NotFound
    raise NotFound.new path: path
  rescue RestClient::RequestFailed => e
    Rails.logger.error "[#{self.class.name}] Failed to fetch path '#{path}' from Storyblok – exception: #{e.inspect}"

    raise CmsAccessError
  end

  private

  def latest_cache_version
    # NOTE: this call will also be cached in Redis, which is beneficial, since
    # we only want to fetch the new cache version when the Redis cache has been
    # invalidated
    @client.space['data']['space']['version']
  end

  def deserialize(hash, mapper, model_class)
    mapped = mapper.map_from hash
    model_class.new mapped
  end
end
