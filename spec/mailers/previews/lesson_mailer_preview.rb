# Preview all emails at http://localhost:3000/rails/mailers/lesson_mailer
class LessonMailerPreview < ActionMailer::Preview
  def lesson_email
    course = CoursesService.new(STORYBLOK_CLIENT).get params[:course]
    lesson = course.lessons[params[:lesson_no].to_i - 1]
    languages = params[:languages].split(',')
    disguised = params[:disguised] == 'true'

    LessonMailer.lesson_email(
      user: User.first,
      course: course,
      lesson: lesson,
      languages: languages,
      disguised: disguised
    )
  end
end
