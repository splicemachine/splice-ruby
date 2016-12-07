# Activerecord::Jdbcsplice::Adapter

Splice Engine JDBC adapter for JRuby on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-jdbcsplice-adapter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-jdbcsplice-adapter

## Usage

To use Splice JDBC adapter, install the gem, and update your `database.yml` like:

```ruby
default: &default
  adapter: jdbcsplice
  username: splice
  password: admin
  prepared_statements: true
  pool: 1000
  host: localhost
  port: 1527

development:
  <<: *default
  database: splicedb

test:
  <<: *default
  database: splicedb_test


production:
  <<: *default
  database: splicedb_production

```
