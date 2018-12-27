class CoursesService
  class CmsAccessError < StandardError; end

  class NotFound < StandardError
    attr_reader :type, :identifier

    def initialize(message = nil, type = nil, identifier = nil)
      @type = type
      @identifier = identifier
      super(message)
    end
  end

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
  rescue RestClient::RequestFailed => e
    Rails.logger.error "[#{self.class.name}] Failed to load the courses list from Storyblok – exception: #{e.inspect}"

    raise CmsAccessError
  end

  def get(slug)
    raise NotFound.new(nil, 'Course', nil) if slug.blank?

    response = @client.story "courses/#{slug}"
    story = response.dig 'data', 'story'
    deserialize_course story
  rescue RestClient::NotFound
    raise NotFound.new(nil, 'Course', slug)
  rescue RestClient::RequestFailed => e
    Rails.logger.error "[#{self.class.name}] Failed to fetch course '#{slug}' from Storyblok – exception: #{e.inspect}"

    raise CmsAccessError
  end

  def get_course_and_lesson(course_slug, lesson_slug)
    raise NotFound.new(nil, 'Lessons', nil) if course_slug.blank? || lesson_slug.blank?

    course = get course_slug
    lesson = course.lessons.find { |l| l.slug == lesson_slug }

    raise NotFound.new(nil, 'Lessons', "#{course_slug}/#{lesson_slug}") if lesson.blank?

    [course, lesson]
  end

  private

  def deserialize_course(hash)
    mapped = CourseMapper.map_from hash
    Course.new mapped
  end
end
