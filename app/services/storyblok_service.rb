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
    @client.story path
  rescue RestClient::NotFound
    raise NotFound.new path: path
  rescue RestClient::RequestFailed => e
    Rails.logger.error "[#{self.class.name}] Failed to fetch path '#{path}' from Storyblok – exception: #{e.inspect}"

    raise CmsAccessError
  end

  private

  def deserialize(hash, mapper, model_class)
    mapped = mapper.map_from hash
    model_class.new mapped
  end
end
