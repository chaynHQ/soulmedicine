# The Primary Algorithm job to calculate which subscriptions are ready to be delivered
# DeliveryAlgorithmJob -> CalculateLessonJob -> LessonDeliveryJob
class DeliveryAlgorithmJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    logger.error exception.message
  end

  def perform(time)
    logger.debug "Starting sending messages for #{time}"
    subscriptions = Subscription.where(:delivery_time_of_day => Time.parse(time).utc)
    subscriptions.each do |s|
      CalculateLessonJob.perform_later s
    end
    logger.debug "Found #{subscriptions.count} #{'subscription'.pluralize(subscriptions.count)}"
  end
end
