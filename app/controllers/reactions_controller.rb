class ReactionsController < ApplicationController
  before_action :require_authentication
  before_action :find_or_initialize_reaction, only: %i[show update destroy]

  def show
    update
  end

  def update
    if @reaction.new_record?
      @reaction.reaction_name = params[:reaction_name]
      @reaction.save!
    else
      @reaction.update!(reaction_name: params[:reaction_name])
    end

    redirect_to redirect_url
  end

  def destroy
    @reaction.destroy if @reaction.persisted?
    redirect_to redirect_url
  end

  private

  def find_or_initialize_reaction
    @reaction = current_user.note_reactions.find_or_initialize_by(course_slug: params[:course_id], lesson_slug: params[:lesson_id])
  end

  def redirect_url
    params[:redirect].presence || course_lesson_path(@reaction.course_slug, @reaction.lesson_slug)
  end
end
