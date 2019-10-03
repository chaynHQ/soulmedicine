class BackupsWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform
    BackupsProcessorService.new.run
  end
end
