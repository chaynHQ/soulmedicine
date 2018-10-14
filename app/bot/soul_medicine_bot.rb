include Facebook::Messenger # rubocop:disable MixinUsage

Bot.on :optin do |optin|
  Rails.logger.debug optin.inspect
  optin.reply(:text => "Ah, human!")
end

Bot.on :message do |message|
  Rails.logger.debug message.inspect
  message.mark_seen
  message.reply(:text => "Hello, human!")
end
