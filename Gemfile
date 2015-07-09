source 'https://rubygems.org'

ruby '2.2.2'

gem 'coffee-rails', '~> 4.1.0'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'hiredis'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'octokit'
gem 'pg'
gem 'rails', github: 'rails/rails', branch: '4-2-stable'
gem 'redis', require: %w(redis redis/connection/hiredis)
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'minitest-rails'
end

group :development do
  gem 'rubocop', require: false
  gem 'parser', '~> 2.2.2', require: false
end

group :test do
  gem 'database_rewinder'
  gem 'minitest-power_assert'
end
