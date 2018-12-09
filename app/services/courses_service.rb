class CoursesService
  def initialize(storyblok_client)
    @client = storyblok_client
  end

  def list
    response = @client.stories(
      starts_with: 'courses',
      excluding_fields: 'lessons'
    )
    stories = response.dig 'data', 'stories'
    Array(stories).map(&method(:deserialize_course))
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "#[{self.class.name}] Failed to load the courses list from Storyblok – exception: #{e.inspect}"
  end

  private

  def deserialize_course(hash)
    Course.new(
      slug: hash.fetch('slug'),
      uuid: hash.fetch('uuid'),
      name: hash.fetch('name')
    )
  end
end
