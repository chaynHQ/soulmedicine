class LessonMailer < ApplicationMailer
  helper :application
  helper :emoji

  def lesson_email(user:, course:, lesson:, languages:, disguised:)
    email_with_name = %("#{user.display_name}" <#{user.email}>)

    @user = user
    @course = course
    @lesson = lesson
    @languages = (LocalesService.enabled & languages.map(&:to_sym))

    @reaction = @user.note_reactions.find_by(course_slug: @course.slug, lesson_slug: @lesson.slug)
    @possible_reactions = NoteReaction.reaction_names.keys

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
