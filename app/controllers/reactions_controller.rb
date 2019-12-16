class ReactionsController < ApplicationController
  before_action :require_authentication, only: %i[update destroy]
  before_action :find_or_initialize_reaction, only: %i[set_from_email update destroy]

  def set_from_email
    @reaction.update!(reaction_name: params[:reaction_name])
    redirect_to redirect_url
  end

  def update
    @reaction.update!(reaction_name: params[:reaction_name])
    redirect_to redirect_url
  end

  def destroy
    @reaction.destroy if @reaction.persisted?
    redirect_to redirect_url
  end

  private

  def find_or_initialize_reaction
    user = action_name.to_sym == :set_from_email ? SignedGlobalID.find(params[:user_id], for: :set_reaction) : current_user

    not_found_error if user.blank?

    @reaction = user.note_reactions.find_or_initialize_by(course_slug: params[:course_id], lesson_slug: params[:lesson_id])
  end

  def redirect_url
    params[:redirect_url].presence || course_lesson_path(@reaction.course_slug, @reaction.lesson_slug)
  end
end
