class VotesController < ApplicationController
  before_action :require_authentication

  before_action :find_or_initialize_vote, only: %i[create destroy]

  def create
    @vote.save!
    respond_to do |format|
      format.js { redirect_to course_path(@vote.course_slug) }
    end
  end

  def destroy
    @vote.destroy if @vote.persisted?
    respond_to do |format|
      format.js { redirect_to course_path(@vote.course_slug) }
    end
  end

  private

  def find_or_initialize_vote
    @vote = current_user.votes.find_or_initialize_by(course_slug: params[:course_id])
  end
end
