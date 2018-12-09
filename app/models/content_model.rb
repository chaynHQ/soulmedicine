class ContentModel
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ShallowAttributes

  attribute :slug, String

  def id
    slug
  end

  def persisted?
    false
  end
end
