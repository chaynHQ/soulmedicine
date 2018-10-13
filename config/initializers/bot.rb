unless Rails.env.production?
    bot_files = Dir[Rails.root.join('app', 'bot', '**', '*.rb')]
    bot_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) do
      bot_files.each{ |file| require_dependency file }
    end
  
    ActiveSupport::Reloader.to_prepare do
      bot_reloader.execute_if_updated
    end
  
    bot_files.each { |file| require_dependency file }
  end