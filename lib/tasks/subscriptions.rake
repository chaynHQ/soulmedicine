namespace :subscriptions do
  desc 'Trigger an async worker to process any subscriptions that need delivering at this moment in time'
  task trigger_worker: :environment do
    SubscriptionsWorker.perform_async
  end
end
