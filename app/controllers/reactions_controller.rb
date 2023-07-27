class ReactionsController < ApplicationController
  before_action :require_authentication, only: %i[update destroy]
  before_action :find_or_initialize_reaction, only: %i[update destroy set_from_email]

  # PUT/PATCH /pathways/:course_id/notes/:lesson_id/reaction
  def update
    @reaction.update!(reaction_name: params[:reaction_name])
    redirect_to redirect_url
  end

  # DELETE /pathways/:course_id/notes/:lesson_id/reaction
  def destroy
    @reaction.destroy! if @reaction.persisted?
    redirect_to redirect_url
  end

  # GET /pathways/:course_id/notes/:lesson_id/reaction/set_from_email
  def set_from_email
    @reaction.update!(reaction_name: params[:reaction_name])
    redirect_to redirect_url
  end

  private

  def find_or_initialize_reaction
    user = action_name.to_sym == :set_from_email ? SignedGlobalID.find(params[:user_id], for: :set_reaction) : current_user

    not_found_error if user.blank?

    @reaction = user.lesson_reactions.find_or_initialize_by(course_slug: params[:course_id], lesson_slug: params[:lesson_id])
  end

  def redirect_url
    if params[:redirect_url].present? && URI(params[:redirect_url]).host == 'soulmedicine.io'
      params[:redirect_url]
    else
      course_lesson_path(@reaction.course_slug, @reaction.lesson_slug)
    end
  end
end
