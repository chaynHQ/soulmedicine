# frozen_string_literal: true

module ApplicationHelper
  def params_with_locale(locale)
    request.params.dup.merge(locale: locale)
  end
end
