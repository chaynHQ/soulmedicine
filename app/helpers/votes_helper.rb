module VotesHelper
  def heart_fill
    @voted = current_user? ? user_voted? : false
    @voted ? 'fas' : 'far'
  end

  def user_voted?
    vote = current_user.votes.where(['course_slug = ?', @course.slug]).first
    !vote.nil? && vote.liked ? true : false
  end
end
