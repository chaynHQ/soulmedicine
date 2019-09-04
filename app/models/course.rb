class Course < ContentModel
  attribute :uuid, String, present: true
  attribute :enabled_languages, Array, of: String
  attribute :image, String
  attribute :created_at, DateTime
  attribute :published_at, DateTime
  attribute :lessons, Array, of: Lesson

  translated_attribute :name
  translated_attribute :summary
  translated_attribute :description

  def next_lesson(slug)
    return lessons.first if slug.blank?

    lesson = nil
    lessons.each_cons(2) do |x, y|
      lesson = y if x.slug == slug
    end
    lesson
  end

  def previous_lesson(slug)
    return lessons.first if slug.blank?

    lesson = nil
    lessons.each_cons(2) do |x, y|
      lesson = x if y.slug == slug
    end
    lesson
  end
end
