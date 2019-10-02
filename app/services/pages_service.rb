class PagesService < StoryblokService
  def get(slug)
    raise NotFound.new(type: 'Page') if slug.blank?

    path = "pages/#{slug}"

    response = fetch path
    story = response.dig 'data', 'story'
    deserialize story, PageMapper, Page
  end

  def get_all
    response = fetch_all "pages"
  end
end
