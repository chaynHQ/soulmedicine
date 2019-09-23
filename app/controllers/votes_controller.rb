class VotesController < ApplicationController
  before_action :require_authentication

  before_action :find_or_initialize_vote, only: %i[create destroy]

  def create
    redirect_to course_path(@vote.course_slug)
  end

  def destroy
    @vote.destroy
    redirect_to course_path(@vote.course_slug)
  end

  private

  def find_or_initialize_vote
    @vote = current_user.votes.find_or_initialize_by(course_slug: params[:course_id])
    @vote.user_id = current_user.id
    @vote.save
  end
end
