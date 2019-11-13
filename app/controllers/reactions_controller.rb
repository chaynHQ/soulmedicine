class ReactionsController < ApplicationController
  before_action :require_authentication

  def create
    @reaction = NoteReaction.create!(
      user: current_user,
      course_slug: params[:course_id],
      lesson_slug: params[:lesson_id],
      reaction_name: params[:reaction_name]
    )
    respond_to do |format|
      format.js { redirect_to redirect_url }
    end
  end

  def update
    @reaction = current_user.note_reactions.find_by(
      course_slug: params[:course_id],
      lesson_slug: params[:lesson_id]
    )
    @reaction.update!(reaction_name: params[:reaction_name])
    respond_to do |format|
      format.js { redirect_to redirect_url }
    end
  end

  # def destroy
  #   @reaction.destroy if @reaction.persisted?
  #   respond_to do |format|
  #     format.js { redirect_to redirect_url }
  #   end
  # end

  private

  def redirect_url
    params[:redirect].presence || course_lesson_path(@reaction.course_slug, @reaction.lesson_slug)
  end
end
