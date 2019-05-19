class PageMapper
  include ContentMapper

  key :slug, from: 'slug'
  key :uuid, from: 'uuid'

  key :title, from: %w[content title]
  key :description, from: %w[content description]
  key :content_html, from: %w[content content_html code]
end
