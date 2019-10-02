class CourseMapper
  include ContentMapper

  key :slug, from: 'slug'
  key :uuid, from: 'uuid'

  key :tags, from: 'tag_list'

  key :enabled_languages, from: %w[content enabled_languages]

  key :image, from: %w[content image]

  key :name,
    from: %w[content name],
    translated: { field: 'text' }

  key :summary,
    from: %w[content summary],
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
