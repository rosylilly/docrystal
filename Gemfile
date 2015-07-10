source 'https://rubygems.org'

ruby '2.2.2'

gem 'action_args'
gem 'aws-sdk', '~> 2.1.4'
gem 'bitters'
gem 'bonsai-elasticsearch-rails', require: %w(elasticsearch/model bonsai/elasticsearch/rails)
gem 'bourbon'
gem 'coffee-rails', '~> 4.1.0'
gem 'dalli'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'event_tracker'
gem 'faraday-http-cache'
gem 'hiredis'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'meta-tags'
gem 'neat'
gem 'octokit'
gem 'pg'
gem 'puma'
gem 'pusher'
gem 'rails', github: 'rails/rails', branch: '4-2-stable'
gem 'redis', require: %w(redis redis/connection/hiredis)
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'

gem 'rails_12factor', group: :productioo

group :development, :test do
  gem 'byebug'
  gem 'fakes3'
  gem 'minitest-rails'
  gem 'spring'
  gem 'web-console', '~> 2.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'parser', '~> 2.2.2', require: false
  gem 'sinatra', require: false
end

group :test do
  gem 'database_rewinder'
  gem 'minitest-around'
  gem 'minitest-power_assert'
  gem 'vcr'
  gem 'webmock'
end
