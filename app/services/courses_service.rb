class CoursesService < StoryblokService
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
    raise NotFound.new(type: 'Course') if slug.blank?

    path = "courses/#{slug}"
    response = fetch path
    story = response.dig 'data', 'story'
    deserialize_course story
  end

  def get_course_and_lesson(course_slug, lesson_slug)
    raise NotFound.new(type: 'Lesson') if course_slug.blank? || lesson_slug.blank?

    course = get course_slug
    lesson = course.lessons.find { |l| l.slug == lesson_slug }

    raise NotFound.new(type: 'Lessons', id: "#{course_slug}/#{lesson_slug}") if lesson.blank?

    [course, lesson]
  end

  private

  def deserialize_course(story)
    deserialize story, CourseMapper, Course
  end
end
