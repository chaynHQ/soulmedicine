Rails.application.config.email_from_address = ENV.fetch('EMAIL_FROM_ADDRESS') { raise 'EMAIL_FROM_ADDRESS missing from env' }

# Check for mailgun specific env vars, otherwise fallback
smtp_address = ENV['MAILGUN_SMTP_SERVER'] || ENV['SMTP_ADDRESS']
smtp_port = (ENV['MAILGUN_SMTP_PORT'] || ENV['SMTP_PORT']).to_i
smtp_user_name = ENV['MAILGUN_SMTP_LOGIN'] || ENV['SMTP_USERNAME']
smtp_password = ENV['MAILGUN_SMTP_PASSWORD'] || ENV['SMTP_PASSWORD']

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  address: smtp_address,
  port: smtp_port,
  user_name: smtp_user_name,
  password: smtp_password,
  authentication: :plain
}

host_uri = if ENV.key?('HEROKU_APP_NAME')
             URI("https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com")
           else
             URI(ENV.fetch('SITE_BASE_URL'))
           end

Rails.application.config.action_mailer.default_url_options = { host: host_uri.hostname }
Rails.application.config.action_mailer.default_url_options[:port] = host_uri.port if host_uri.port != host_uri.default_port
Rails.application.config.action_mailer.asset_host = host_uri.to_s
