class CoursesController < ApplicationController
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

  def show
    @course = courses_service.get params[:id]

    @subscription = (current_user.subscriptions.find_by(course_slug: @course.slug) if current_user?)

    @vote_total = Vote.get_course_vote_total(@course.slug)
  end
end
