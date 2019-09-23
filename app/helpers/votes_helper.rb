module VotesHelper
  def user_voted?
    vote = current_user.votes.where(['course_slug = ?', @course.slug]).first
    !vote.nil? ? true : false
  end

  def heart_fill
    voted = current_user? ? user_voted? : false
    voted ? 'fas' : 'far'
  end

  def vote_method
    voted = current_user? ? user_voted? : false
    voted ? 'delete' : 'post'
  end
end
