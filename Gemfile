source 'https://rubygems.org'

ruby '2.3.1', :engine => 'jruby', :engine_version => '9.1.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'

platforms :jruby do
  # JDBC database adapters for database
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsplice-adapter'
end

platforms :ruby do
  gem 'mysql2'
end

# Server
gem 'puma'
# Timeout notification (used in relation with puma)
gem "rack-timeout"


# UI gems and a decorator
gem 'jquery-rails'
gem "twitter-bootstrap-rails"
gem 'draper'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'


# Background Workers
gem 'sidekiq'


group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'byebug', platform: :ruby
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'simplecov', :require => false
end

group :development do
  gem 'better_errors'
end

group :development do
  # Used for deplying to heroku
  gem 'rails_12factor'
end
