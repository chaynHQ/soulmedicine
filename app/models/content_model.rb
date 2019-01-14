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

  def self.translated_attribute(name)
    LocalesService.enabled.each do |l|
      attribute "#{name}_#{l}".to_sym, String
    end

    define_method name do
      send "#{name}_#{LocalesService.current}"
    end
  end
end
