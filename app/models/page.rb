class Page < ContentModel
  attribute :title, String, present: true
  attribute :description, String, present: true
  attribute :content_html, String, present: true
end
