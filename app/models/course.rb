class Course < ContentModel
  attribute :uuid, String
  attribute :name, String
  attribute :created_at, DateTime
  attribute :published_at, DateTime
  attribute :lessons, Array, of: Lesson
end
