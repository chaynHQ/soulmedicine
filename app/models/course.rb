class Course < ContentModel
  attribute :uuid, String, present: true
  attribute :created_at, DateTime
  attribute :published_at, DateTime
  attribute :lessons, Array, of: Lesson

  translated_attribute :name
  translated_attribute :description
end
