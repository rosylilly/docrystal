redis_url = ENV['REDIS_URL'] || ENV['REDISCLOUD_URL'] || nil

redis_conn = proc do
  Redis.new(url: redis_url)
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
