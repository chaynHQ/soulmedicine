class Page < ContentModel
  attribute :full_width, 'Boolean', default: false
  attribute :title, String, present: true
  attribute :description, String, present: true
  attribute :content_html, String, present: true
end
