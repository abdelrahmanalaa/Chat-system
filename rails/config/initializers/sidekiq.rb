Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_CONNECTION_STRING'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_CONNECTION_STRING'] }
end

