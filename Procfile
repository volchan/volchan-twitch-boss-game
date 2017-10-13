web: bundle exec puma -C config/puma.rb
worker: bundle exec rake sidekiq_cron:load -C config/sidekiq_cron.yml
worker: bundle exec sidekiq -C config/sidekiq.yml
