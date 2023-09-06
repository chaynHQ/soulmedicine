class LessonMailer < ApplicationMailer
  helper :application
  helper :emoji

  def lesson_email
    @user = params[:user]
    email_with_name = %("#{@user.display_name}" <#{@user.email}>)

    @course = params[:course]
    @lesson = params[:lesson]
    @languages = (LocalesService.enabled & Array(params[:languages]).map(&:to_sym))

    @reaction = @user.lesson_reactions.find_by(course_slug: @course.slug, lesson_slug: @lesson.slug)
    @possible_reactions = LessonReaction.reaction_names.keys

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
