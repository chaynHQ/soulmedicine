class LessonMailer < ApplicationMailer
  DISGUISED_SUBJECT_LINES = [
    'Horoscope Reminder',
    'Funniest Videos',
    'News and Weather'
  ].freeze

  helper :application

  def lesson_email(user:, course:, lesson:, languages:, disguised:)
    email_with_name = %("#{user.display_name}" <#{user.email}>)

    @user = user
    @course = course
    @lesson = lesson
    @languages = (LocalesService.enabled & languages.map(&:to_sym))

    subject = if disguised
                DISGUISED_SUBJECT_LINES.sample
              else
                lesson.name
              end

    LocalesService.with(@languages.first) do
      mail(to: email_with_name, subject: subject)
    end
  end
end
