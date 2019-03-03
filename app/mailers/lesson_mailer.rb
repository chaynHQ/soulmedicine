class LessonMailer < ApplicationMailer
  helper :application

  def lesson_email(user:, course:, lesson:, languages:)
    email_with_name = %("#{user.display_name}" <#{user.email}>)

    @course = course
    @lesson = lesson
    @languages = (LocalesService.enabled & languages.map(&:to_sym))

    LocalesService.with(@languages.first) do
      mail(to: email_with_name, subject: lesson.name)
    end
  end
end
