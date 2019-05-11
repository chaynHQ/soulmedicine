# frozen_string_literal: true

module ApplicationHelper
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

  def title(page_title)
    content_for(:title) { page_title }
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

  def icon(name, size: '1x')
    tag.i '', class: "fas fa-#{name} fa-#{size}"
  end

  def rtl?
    LocalesService.current_rtl?
  end

  def text_direction
    rtl? ? 'rtl' : 'ltr'
  end

  def humanize_boolean(value)
    if value
      t('phrases.yes')
    else
      t('phrases.no')
    end
  end
end
