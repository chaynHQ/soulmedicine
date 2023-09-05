class SubscriptionsProcessorService
  BATCH_SIZE = 20

  def run
    Subscription
      .active
      .in_batches(of: BATCH_SIZE)
      .each_record(&method(:process))
  end

  private

  def process(subscription)
    return unless deliver_subscription_now?(subscription)

    deliver subscription
  end

  def deliver_subscription_now?(subscription)
    subscription.active? &&
      subscription.email? &&
      subscription.user.verified? &&
      within_schedule?(subscription) &&
      !delivered_within_last_hour?(subscription) &&
      course_ok?(subscription)
  end

  def course_ok?(subscription)
    if subscription.course.blank?
      Rails.logger.warn "Course '#{subscription.course_slug}' not found! (Subscription: #{subscription.id})"
      return false
    end

    return true if subscription.course.enabled_languages.include?(subscription.main_language)

    Rails.logger.warn [
      "A subscription for course '#{subscription.course_slug}'",
      "has requested main language: #{subscription.main_language},",
      "but the course only has enabled language(s): #{course.enabled_languages.to_sentence}",
      "(Subscription: #{subscription.id})"
    ].join(' ')

    false
  end

  def within_schedule?(subscription)
    now = Time.now.utc
    day = now.strftime('%a')
    hour = now.hour

    subscription.days_utc.include?(day) &&
      subscription.hours_utc.include?(hour)
  end

  def delivered_within_last_hour?(subscription)
    return false if subscription.last_delivered_at.blank?

    delivered_ago_hours = ((Time.now.utc - subscription.last_delivered_at.utc) / 1.hour).round(2)
    delivered_ago_hours < 1.0
  end

  def deliver(subscription)
    Rails.logger.info "Attempting to deliver subscription #{subscription.id} for course '#{subscription.course_slug}'"

    lesson = subscription.course.next_lesson(subscription.lessons_delivered.last)

    return false unless lesson

    languages = ([subscription.main_language] + subscription.other_languages).compact.uniq

    LessonMailer.lesson_email(
      user: subscription.user,
      course: subscription.course,
      lesson: lesson,
      languages: languages,
      disguised: subscription.disguised
    ).deliver_now

    subscription.update!(
      lessons_delivered: subscription.lessons_delivered.concat([lesson.slug]),
      last_delivered_at: Time.now.utc
    )

    true
  rescue StandardError => e
    error_serialised = "[#{e.class.name}] #{e.message} - #{e.backtrace.join(' | ')}"

    Rails.logger.error [
      "Failed to deliver subscription #{subscription.id}",
      "for course '#{subscription.course_slug}'",
      "- error: #{error_serialised}"
    ].join(' ')
  end
end
