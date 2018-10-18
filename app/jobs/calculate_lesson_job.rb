# Job to calculate what the next lesson is
class CalculateLessonJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    logger.error exception.message
  end

  def perform(subscription)
    @lesson = subscription.lesson
    if @lesson.next?
      LessonDeliveryJob.perform_later subscription, @lesson.next
    else
      case subscription.delivery_method
      when "email"
        LessonDeliveryJob.complete(subscription.user, @lesson).deliver_later
      else
        raise "Unknown delivery method"
      end
    end
  end
end
