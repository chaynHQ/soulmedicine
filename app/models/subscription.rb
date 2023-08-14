class Subscription < ApplicationRecord
  extend Memoist

  HOURS = (0..23).to_a.freeze

  TIMEZONE_IDS = ActiveSupport::TimeZone.all.map(&:name).freeze

  scope :active, -> { where(active: true) }

  belongs_to :user

  enum delivery_method: {
    email: 'email'
  }

  validates :course_slug,
    presence: true,
    uniqueness: { scope: :user_id }

  validates :active, inclusion: [true, false]

  validates :main_language,
    presence: true,
    length: { is: 2 }

  validates :delivery_method, presence: true

  validates :user_timezone,
    inclusion: { in: TIMEZONE_IDS }
  validates :days_utc,
    presence: true
  validates :hours_utc,
    presence: true,
    length: { is: 1 } # For now we only support one time slot (to make it easier to translate to/from the user's timezone)

  validate :validate_course_exists
  validate :validate_languages
  validate :validate_schedule

  def days
    converted_schedule[:days]
  end

  def hour
    converted_schedule[:hour]
  end

  def course
    courses_service.get(course_slug) if course_slug.present?
  rescue CoursesService::NotFound
    nil
  end
  memoize :course

  def pause!
    update! active: false
  end

  def unpause!
    update! active: true
  end

  protected

  def converted_schedule
    TimeZoneScheduleConverter.convert(
      from_zone: 'UTC',
      to_zone: user_timezone,
      days: days_utc,
      hour: hours_utc.first
    )
  end

  def validate_course_exists
    errors.add(:base, 'course is not available') if course.blank?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def validate_languages
    return if course.blank?

    errors.add(:other_languages, 'cannot contain the same langguage as the main language') if other_languages.any? { |l| l == main_language }

    main_allowed = course.enabled_languages.compact
    errors.add(:main_language, "can only be #{main_allowed.to_sentence(last_word_connector: ' or ')}") unless main_allowed.include?(main_language)

    return if other_languages.blank?

    other_allowed = main_allowed - [main_language]
    errors.add(:other_languages, "can only contain #{other_allowed.to_sentence}") if other_languages.any? { |l| !other_allowed.include?(l) }
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def validate_schedule
    errors.add(:days_utc, "can only contain #{Date::ABBR_DAYNAMES.to_sentence}") if days_utc.any? { |d| !Date::ABBR_DAYNAMES.include?(d) }

    errors.add(:hours_utc, "can only contain #{HOURS.to_sentence}") if hours_utc.any? { |h| !HOURS.include?(h) }
  end
end
