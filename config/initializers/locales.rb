require_relative '../../app/services/locales_service'

enabled_locales_var = ENV.fetch('ENABLED_LOCALES') { raise 'ENABLED_LOCALES missing' }
enabled_locales = enabled_locales_var.split(',').map(&:strip).map(&:downcase).map(&:to_sym)

LocalesService.enabled = enabled_locales

LocalesService.default = :en
