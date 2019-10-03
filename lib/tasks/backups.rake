namespace :backups do
  desc 'Trigger an async worker to backup all content from storyblok into the db'
  task trigger_worker: :environment do
    BackupsWorker.perform_async
  end
end
