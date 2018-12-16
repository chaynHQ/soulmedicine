class Course < ContentModel
  attribute :uuid, String, present: true
  attribute :name, String, present: true
  attribute :created_at, DateTime
  attribute :published_at, DateTime
  attribute :lessons, Array, of: Lesson
end
