class LessonMapper
  include ContentMapper

  key :slug, from: 'slug'

  key :name,
    from: 'name',
    translated: { field: 'text' }

  key :content,
    from: 'content',
    translated: { field: 'content' },
    is_markdown: true
end
