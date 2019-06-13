class SettingsMapper
  include ContentMapper

  disguised_subject_lines_mapper = lambda do |value|
    if value.is_a? String
      value
        .split(/\n+/)
        .map(&:strip)
        .reject(&:blank?)
    end
  end

  key :disguised_subject_lines,
    from: %w[content disguised_subject_lines],
    mapper: disguised_subject_lines_mapper,
    default: []

  key :courses_bg_image, from: %w[content courses_bg_image]
end
