module ReactionsHelper
  def user_reacted?(user, course_slug, lesson_slug)
    user.note_reactions.exists?(course_slug: course_slug, lesson_slug: lesson_slug)
  end

  def reaction_method(user, course_slug, lesson_slug)
    reacted = user_reacted?(user, course_slug, lesson_slug)
    reacted ? 'patch' : 'post'
  end
end
