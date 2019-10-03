module SubscriptionsHelper
  def subscription_other_languages_options(subscription)
    (
      subscription.course.enabled_languages -
        [subscription.main_language]
    ).flatten
      .map do |l|
        [LocalesService.language_name(l), l]
      end
  end

  def subscription_hours_options
    Subscription::HOURS.map do |h|
      [subscription_format_hour_slot(h), h]
    end
  end

  def subscription_format_hour_slot(hour)
    "#{format('%02d', hour)}:00 - #{format('%02d', (hour + 2))}:00" # rubocop:disable Style/FormatStringToken
  end

  def subscription_unsubscribe_button(subscription, css_class: nil)
    link_to t('phrases.unsubscribe').capitalize,
      course_subscription_path(subscription.course),
      method: :delete,
      class: css_class,
      data: {
        title: t('subscriptions.shared.unsubscribe_confirm_title', course_name: subscription.course.name),
        confirm: t('subscriptions.shared.unsubscribe_confirm_text')
      },
      role: 'button'
  end
end
