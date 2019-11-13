module EmojiHelper
  # Most emojis are included already by the gemoji gem, however for space
  # issues we have removed the majority of the backup images
  # To include an additional emoji, locate the image from
  # https://emojipedia.org/ and store as a png file in app/webpack/images/emoji/unicode
  # If emoji is not included by the gremoji gem - determined by running your
  # code in browser and checking if an emoji is returned or not. You will need
  # to add it to the global Emoji object like done below.

  Emoji.create('brain') do |char|
    char.add_unicode_alias "\u{1f9e0}"
  end

  emoji_names_to_reactions = { 'brain' => 'knowledable', 'crown' => 'empowered', 'muscle' => 'strong', 'unicorn' => 'magical', 'dove' => 'peaceful' }

  emoji_names_to_reactions.each do |emoji_name, reaction|
    # rubocop:disable Rails/DynamicFindBy
    emoji = Emoji.find_by_alias(emoji_name)
    # rubocop:enable Rails/DynamicFindBy
    Emoji.edit_emoji(emoji) do |char|
      char.add_alias(reaction)
    end
  end

  def emojify(content)
    return if content.blank?

    h(content).to_str.gsub(/:([\w+-]+):/) do
      # rubocop:disable Rails/DynamicFindBy
      return unless (emoji = Emoji.find_by_alias(Regexp.last_match(1)))

      # rubocop:enable Rails/DynamicFindBy
      %(<img alt="#{Regexp.last_match(1)}"
        src="#{asset_pack_path("media/images/emoji/#{emoji.image_filename}")}"
        class="emoji"/>)
    end
  end
end
