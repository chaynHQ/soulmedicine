class SubscriptionsWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform
    SubscriptionsProcessorService.new.run
  end
end
