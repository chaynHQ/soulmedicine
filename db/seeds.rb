# frozen_string_literal: true

require 'faker'
require 'ruby-progressbar'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Internal: Randomly selects True or False.
#
# Returns a Boolean.
def rand_bool
  [true, false].sample
end

def rand_utc_schedule(users_timezone)
  TimeZoneScheduleConverter.convert(
    from_zone: users_timezone,
    to_zone: 'UTC',
    days: Date::ABBR_DAYNAMES.sample(rand(1..7)),
    hour: rand(0..23)
  )
end

# Internal: Randomly select the main language and 'other' language options for
# a course subscription.
#
# languages - The Array of Strings that represent the languages offered.
#
# Examples
#
#   rand_languages(["en", "ur"])
#   # => { main_language: "en", other_languages: ["ur"] }
#
# Returns a Hash.
def rand_languages(languages)
  langs = languages.dup

  rand_index = (0...languages.count)
  main_language = langs.delete_at(rand(rand_index))

  { main_language: main_language, other_languages: langs }
end

# Internal: Randomly select the lessons delivered for a given course
# subscription.
#
# Returns an Array of Strings representing the lessons.
def rand_lessons_delivered_for(course)
  return [] unless course[:lessons].any?

  number_of_lessons = course[:lessons].length
  range = number_of_lessons - 1

  course[:lessons].slice(0..range)
end

def story_blok_courses
  courses_service = CoursesService.new(STORYBLOK_CLIENT)
  courses_response = courses_service.all

  stories = courses_response.dig('data', 'stories')

  stories.each_with_object({}) do |story, hash|
    key = story['slug']

    hash[key] = {
      enabled_languages: story.dig('content', 'enabled_languages'),
      lessons: story.dig('content', 'lessons').map { |lesson| lesson['slug'] }
    }
  end
end

users = []

puts "\n== Generating Users ==" # rubocop:disable Rails/Output

1000.times do
  users << {
    display_name: Faker::Name.name,
    firebase_id: SecureRandom.alphanumeric(32),
    email: Faker::Internet.unique.email,
    email_verified: rand_bool,
    terms_accepted: rand_bool
  }
end

User.create(users)

puts "\n== Fetching data from Storyblok ==" # rubocop:disable Rails/Output
courses = story_blok_courses

s_progress_bar = ProgressBar.create(title: '== Creating Subscriptions ==', total: User.count)

User.all.each do |user|
  subscriptions = []
  users_timezone = Subscription::TIMEZONE_IDS.sample

  courses.keys.sample(rand(0..5)).each do |slug|
    course = courses[slug]

    languages = rand_languages(course[:enabled_languages])
    timestamp = Time.zone.now
    utc_schedule = rand_utc_schedule(users_timezone)

    subscriptions << {
      user_id: user.id,
      course_slug: slug,
      active: rand_bool,
      main_language: languages[:main_language],
      other_languages: languages[:other_languages],
      days_utc: utc_schedule[:days],
      hours_utc: [utc_schedule[:hour]],
      lessons_delivered: rand_lessons_delivered_for(course),
      user_timezone: users_timezone,
      disguised: rand_bool,
      created_at: timestamp,
      updated_at: timestamp
    }
  end

  s_progress_bar.increment
  next unless subscriptions.any?

  Subscription.insert_all(subscriptions) # rubocop:disable Rails/SkipsModelValidations
end
