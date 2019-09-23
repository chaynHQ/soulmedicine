module VotesHelper
  def heart_fill
    @voted = user_voted?
    @voted ? 'fas fa-heart' : 'far fa-heart'
  end

  def user_voted?
    vote = current_user.votes.where(['course_slug = ?', @course.slug]).first
    !vote.nil? && vote.liked ? true : false
  end
end
