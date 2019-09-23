module VotesHelper

  def heart_fill

    @voted = has_user_voted
    return @voted ?  'fas fa-heart' : 'far fa-heart'

  end

  def has_user_voted

    vote = current_user.votes.where(["course_slug = ?", @course.slug]).first
    return vote.liked ? true : false

  end

end
