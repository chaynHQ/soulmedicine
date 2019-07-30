class LessonMailer < ApplicationMailer
  helper :application

  def lesson_email(user:, course:, lesson:, languages:, disguised:)
    email_with_name = %("#{user.display_name}" <#{user.email}>)

    @user = user
    @course = course
    @lesson = lesson
    @languages = (LocalesService.enabled & languages.map(&:to_sym))

    subject = if disguised
                disguised_subject_line
              else
                lesson.name
              end

    LocalesService.with(@languages.first) do
      attachments.inline['icon.png'] = URI.parse(@course.image).read
      mail(to: email_with_name, subject: subject)
    end
  end

  private

  def disguised_subject_line
    SettingsService
      .new(STORYBLOK_CLIENT)
      .get
      .disguised_subject_lines
      .sample
  end
end
