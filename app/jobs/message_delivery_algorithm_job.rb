# This job finds the user subscriptions and the messages that need to be sent
class MessageDeliveryAlgorithmJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    logger.error exception.message
  end

  def perform(time_of_day)
    logger.debug "Starting sending messages for #{time_of_day}"
    subscriptions = find_subscriptions(time_of_day)
    logger.info "Found #{subscriptions.count} #{'user'.pluralize(subscriptions.count)} to send"\
                " messages for"
    send_messages(subscriptions)
    logger.debug "Finished sending messages"
  end

  def find_users(time_of_day)
    case time_of_day
    when "morning"
      Subscription.morning_users
    when "afternoon"
      Subscription.afternoon_users
    when "evening"
      Subscription.evening_users
    else
      Subscription.active
  end

    def send_messages(subscriptions)
      logger.debug "Gathering all subscriptions"
      subscriptions.each do |u|
        logger.debug "Starting algorithm for user_id: #{u.user_id}"
        # Get the Course(s) that the user is subscribed to(returns array)
        user_courses = u.active_courses
        user_courses.each do |uc|
          logger.debug "Course found. Course_id: #{uc.course_id}"
          logger.debug "Finding lessons that the user has completed for course"
          # Get the Lessons that the user has completed
          user_lesson_completions = u.completed_lessons_for_course(uc.course_id)
          # If the User has not yet started on the course,
          # then send the first lesson of the first
          # subject on that course
          if user_lesson_completions.empty?
            logger.debug "User has not completed any lessons for this course"
            logger.debug "Sending the first lesson of the first subject"
            subject = uc.course.subjects.active.order(:sequential_id).first
            if subject.present?
              lesson = subject.lessons.active.first
              logger.info "Sending lesson #{lesson.id} for subject: #{subject.name}"
              FindMessageTranslationJob.perform_later(u, lesson)
            else
              logger.warn "There are no subjects assigned to this course"
            end
          else # If the User has indeed started the course
            last_lesson_sent = u.completed_lessons_for_course(uc.course_id).last
            # If the last lesson that was sent is not the last
            # lesson in the subject, then send the next
            # lesson, otherwise proceed to next check
            if last_lesson_sent.lesson.next.present?
              logger.debug "Sending the next lesson in the subject"
              lesson = last_lesson_sent.lesson.next
              logger.info "Sending lesson #{lesson.id} for subject: #{lesson.subject.name}"
              FindMessageTranslationJob.perform_later(u, lesson)
            else
              logger.debug "No more lessons found for subject"
              # If the last lesson sent was the last lesson in the
              # subject, then move on to the next subject's first lesson
              if last_lesson_sent.subject.next.present?
                logger.debug "Starting the next subject on this course for this user: #{u.id}"
                lesson = last_lesson_sent.subject.next.lessons.active.first
                logger.debug "Sending lesson #{lesson.id} for subject: #{lesson.subject.name}"
                FindMessageTranslationJob.perform_later(u, lesson)
              else
                logger.debug "Course has been completed by the user"
                user_course = UserCourse.find(uc.id)
                user_course.is_complete = true
                user_course.save
              end
            end
          end
        end
      end
    end
  end
end
