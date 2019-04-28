class SettingsService < StoryblokService
  def get
    response = fetch '/settings'
    story = response.dig 'data', 'story'
    deserialize story, SettingsMapper, Settings
  end
end
