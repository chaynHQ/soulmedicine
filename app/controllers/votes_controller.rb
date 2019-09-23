class VotesController < ApplicationController
  def create

    if !current_user?
      flash[:alert] = 'Please sign in to vote'
      redirect_to auth_sign_in_path
    else

      @votes = current_user.votes

      vote = @votes.find_or_initialize_by(course_slug: params[:course_slug])
      vote.user_id = current_user.id
      vote.liked = !vote.liked
      vote.save

      redirect_to course_path(vote.course_slug)

    end
  end
end
