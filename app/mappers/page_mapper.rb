class PageMapper
  include ContentMapper

  key :slug, from: 'slug'
  key :uuid, from: 'uuid'

  key :content_html, from: %w[content content_html]
end
