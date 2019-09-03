class CoursesService < StoryblokService
  def list
    response = @client.stories(
      starts_with: 'courses',
      excluding_fields: 'lessons',
      cache_version: latest_cache_version
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
    current_lesson = course.lessons.find { |l| l.slug == lesson_slug }
    next_lesson = get_next_lesson(course.lessons, lesson_slug)
    previous_lesson = get_previous_lesson(course.lessons, lesson_slug)

    raise NotFound.new(type: 'Lessons', id: "#{course_slug}/#{lesson_slug}") if current_lesson.blank?

    [course, current_lesson, next_lesson, previous_lesson]
  end

  def get_next_lesson(lessons, lesson_slug)
    next_lesson = nil
    lessons.each_cons(2) do |x, y|
      next_lesson =  y if x.slug == lesson_slug
    end
    next_lesson
  end

  def get_previous_lesson(lessons, lesson_slug)
    previous_lesson = nil
    lessons.each_cons(2) do |x, y|
      previous_lesson =  x if y.slug == lesson_slug
    end
    previous_lesson
  end

  private

  def deserialize_course(story)
    deserialize story, CourseMapper, Course
  end
end
