module ApplicationHelper
  DEFAULT_IMAGE_META_TAG = 'https://a.storyblok.com/f/50602/200x200/8815278a23/favicon.png'.freeze

  def settings
    SettingsService.new(STORYBLOK_CLIENT).get
  end

  def google_analytics
    return if Rails.application.config.google_analytics_id.blank?

    analytics_id = Rails.application.config.google_analytics_id

    safe_join(
      [
        raw( # rubocop:disable Rails/OutputSafety
          <<-GA
          <script async src="https://www.googletagmanager.com/gtag/js?id=#{analytics_id}"></script>
          <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '#{analytics_id}');

            document.addEventListener('turbolinks:load', event => {
              if (typeof gtag === 'function') {
                gtag('config', '#{analytics_id}', {
                  'page_location': event.data.url
                });
              }
            });
          </script>
          GA
        )
      ]
    )
  end

  def default_image_meta_tag
    DEFAULT_IMAGE_META_TAG
  end

  # rubocop:disable Rails/HelperInstanceVariable
  def main_container_class
    is_courses_index = current_page? courses_path
    is_auth_sign_in_path = current_page? auth_sign_in_path
    is_course_page = @course.present? && current_page?(course_path(@course.slug))

    case
    when is_courses_index || is_auth_sign_in_path || is_course_page
      return 'container_fluid'
    when !defined?(@page)
      return 'container'
    else
      return ['page-container', @page.full_width ? 'container-fluid' : 'container'].join(' ')
    end
  end
  # rubocop:enable Rails/HelperInstanceVariable

  def main_style
    is_courses_index = current_page? courses_path

    return '' unless is_courses_index

    image_url = settings.courses_bg_image

    "background: url('#{image_url}');"
  end

  def params_with_locale(locale)
    request.params.dup.merge(locale: locale)
  end

  # For translated content
  def tc(value)
    value.presence || tag.span('Missing translated content', class: 'missing-translated-content')
  end

  def header_nav_item(text, path, alternate_path: nil, icon_name: nil)
    is_active = current_page? path
    is_active ||= current_page?(alternate_path) if alternate_path
    li_classes = ['nav-item']
    li_classes << 'active' if is_active

    tag.li class: li_classes do
      link_to path, class: 'nav-link' do
        concat(icon(icon_name)) if icon_name
        concat(tag.span(text))
        tag.span(t('site-header.active'), class: 'sr-only') if is_active
      end
    end
  end

  def header_nav_separator
    tag.li ' ', class: 'nav-item nav-link'
  end

  def icon(name, css_class: '', variant: 'fas', size: '1x')
    tag.i '', class: "#{variant} fa-#{name} fa-#{size} #{css_class}"
  end

  def language_class(lang = LocalesService.current)
    "lang-#{lang}"
  end

  def text_direction
    rtl? ? 'rtl' : 'ltr'
  end

  def rtl?
    LocalesService.current_rtl?
  end

  def humanize_boolean(value)
    if value
      t('phrases.yes')
    else
      t('phrases.no')
    end
  end
end
