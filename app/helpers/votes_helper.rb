module VotesHelper
  def user_voted?(user, course_slug)
    user.votes.exists? course_slug: course_slug
  end

  def heart_fill(user, course_slug)
    voted = user ? user_voted?(user, course_slug) : false
    voted ? 'fas' : 'far'
  end

  def vote_method(user, course_slug)
    voted = user ? user_voted?(user, course_slug) : false
    voted ? 'delete' : 'post'
  end
end
