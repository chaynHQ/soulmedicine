class CourseMapper
  include ContentMapper

  key :slug, from: 'slug'
  key :uuid, from: 'uuid'

  key :name,
    from: %w[content name],
    translated: { field: 'text' }

  key :description,
    from: %w[content description],
    translated: { field: 'content' },
    is_markdown: true

  key :lessons,
    from: %w[content lessons],
    mapper: LessonMapper,
    default: []
end
