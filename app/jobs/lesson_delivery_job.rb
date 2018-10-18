# Job to delivery individual lessons
class LessonDeliveryJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    logger.error exception.message
  end

  def perform(subscription, lesson)
    @user = subscription.user
    @lesson = lesson
    case subscription.delivery_method
    when "email"
      LessonDeliveryJob.lesson(@user, @lesson).deliver_later
    else
      raise "Unknown delivery method"
    end
  end
end
