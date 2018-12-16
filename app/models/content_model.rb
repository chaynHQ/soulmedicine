class ContentModel
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ShallowAttributes

  attribute :slug, String, present: true

  def id
    slug
  end

  def persisted?
    true
  end
end
