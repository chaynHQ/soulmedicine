class CoursesController < ApplicationController
  # GET /pathways
  def index
    current_locale = LocalesService.current.to_s

    all_courses = courses_service.list

    @courses, @other_courses = all_courses.partition do |c|
      c.enabled_languages.include? current_locale
    end

    @courses_votes = Vote.course_totals(all_courses.map(&:slug))

    @courses_current_user_subscriptions = if current_user?
                                            current_user
                                              .subscriptions
                                              .group_by(&:course_slug)
                                              .transform_values(&:first)
                                          else
                                            {}
                                          end
  end

  # GET /pathways/:id
  def show
    @course = courses_service.get params[:id]

    @vote_total = Vote.get_course_vote_total(@course.slug)

    return unless current_user?

    @subscription = current_user.subscriptions.find_by(course_slug: @course.slug)

    @reactions = current_user.note_reactions.where(course_slug: @course.slug).map { |r| [r.lesson_slug, r.reaction_name] }.to_h

    @progress = current_user.progresses.where(course_slug: @course.slug).map(&:lesson_slug)
  end
end
