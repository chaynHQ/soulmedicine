module LocalesService
  module_function

  RTL_LOCALES = %i[ar fa he iw ur].freeze

  def current
    I18n.locale
  end

  def current=(locale)
    I18n.locale = enabled?(locale) ? locale : default
  end

  def enabled
    I18n.available_locales
  end

  def enabled=(locales)
    Rails.application.config.i18n.available_locales = locales
  end

  def enabled?(locale)
    I18n.locale_available? locale.to_sym
  end

  def default
    I18n.default_locale
  end

  def default=(locale)
    Rails.application.config.i18n.default_locale = locale
    Rails.application.config.i18n.fallbacks = [locale]
  end

  def rtl?(locale)
    RTL_LOCALES.include? locale.to_sym
  end

  def current_rtl?
    rtl? LocalesService.current
  end

  def language_name(lang, in_locale: lang)
    lang.to_sym.localize(in_locale).as_language_code
  end

  def with(locale, &block)
    I18n.with_locale(locale, &block)
  end
end
