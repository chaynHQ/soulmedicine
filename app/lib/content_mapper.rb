module ContentMapper
  extend ActiveSupport::Concern

  included do
    mattr_accessor :keys
    self.keys = []
  end

  class_methods do # rubocop:disable Metrics/BlockLength
    def key(name, from:, translated: false, mapper: nil, is_markdown: false, default: nil)
      raise ArgumentError, "[ContentMapper] 'from' needs to be specified and not blank" if from.blank?

      core_options = {
        from: Array(from),
        mapper: mapper,
        is_markdown: is_markdown,
        default: default
      }

      if translated
        raise ArgumentError, "[ContentMapper] 'translated' must have a `field` specified and not blank" if translated[:field].blank?

        LocalesService.enabled.each do |lang|
          keys << {
            name: "#{name}_#{lang}".to_sym,
            lang: lang,
            translated: translated
          }.merge(core_options)
        end
      else
        keys << { name: name }.merge(core_options)
      end
    end
    protected :key

    def map_from(hash)
      keys.each_with_object({}) do |config, obj|
        obj[config[:name]] = map_value hash, config
      end
    end

    def map_value(hash, config)
      hash
        .dig(*config[:from])
        .yield_self { |v| config[:translated] ? fetch_translation(v, config[:lang], config[:translated]) : v }
        .yield_self { |v| apply_mapper(v, config[:mapper]) }
        .yield_self { |v| config[:is_markdown] ? convert_markdown(v) : v }
        .yield_self { |v| apply_default(v, config[:default]) }
    end
    protected :map_value

    def fetch_translation(entries, lang, options)
      raise ArgumentError, '[ContentMapper] lang cannot be blank' if lang.blank?

      entry = entries.find do |e|
        lang == e.with_indifferent_access[:lang].try(:downcase).try(:to_sym)
      end

      return entry if entry.blank?

      if LocalesService.rtl? lang
        entry.with_indifferent_access["#{options[:field]}_rtl"]
      else
        entry[options[:field]]
      end
    end

    def apply_mapper(value, mapper)
      return value if value.blank? || mapper.nil?

      # If the `mapper` is a Proc or lambda, then use that directly,
      # otherwise assume that it's another ContentMapper.
      if mapper.respond_to? :call
        mapper.call value
      else
        case value
        when Array
          value.map { |v| mapper.map_from v }
        when Hash
          mapper.map_from value
        else
          raise "[Mapper] only Array and Hash values can be further mapped with another ContentMapper - got #{value.class.name}"
        end
      end
    end
    protected :apply_mapper

    def apply_default(value, default)
      return value unless value.nil?
      return value if default.nil?

      default.deep_dup
    end
    protected :apply_default

    def convert_markdown(content)
      return content if content.blank?

      CommonMarker.render_html(
        content,
        %i[HARDBREAKS TABLE_PREFER_STYLE_ATTRIBUTES],
        %i[autolink tagfilter]
      )
    end
    protected :convert_markdown
  end
end
