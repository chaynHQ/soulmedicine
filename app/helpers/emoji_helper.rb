module EmojiHelper
  
  # Most emojis are included already by the gemoji gem, however for space 
  # issues we have removed the majority of the backup images
  # To include an additional emoji, locate the image from 
  # https://emojipedia.org/ and store as a png file in app/webpack/images/emoji/unicode
  # If emoji is not included by the gremoji gem - determined by running your 
  # code in browser and checking if an emoji is returned or not. You will need 
  # to add it to the global Emoji object like done below.
  
  Emoji.create("brain") do |char|
    char.add_unicode_alias "\u{1f9e0}"
  end

  def emojify(content)
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        puts emoji.image_filename
        puts asset_pack_path("media/images/emoji/#{emoji.image_filename}")
        %(<img alt="#$1" src="#{asset_pack_path("media/images/emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end
end