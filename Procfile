web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -t 25 -c 5
release: bin/heroku_release
