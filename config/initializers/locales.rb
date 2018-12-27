enabled_locales_var = ENV.fetch('ENABLED_LOCALES') { raise 'ENABLED_LOCALES missing' }

Rails.application.config.i18n.available_locales = enabled_locales_var.split(',').map(&:strip).map(&:downcase).map(&:to_sym)

Rails.application.config.i18n.default_locale = :en
Rails.application.config.i18n.fallbacks = [:en]

Rails.application.config.rtl_locales = %i[ar iw ur]
