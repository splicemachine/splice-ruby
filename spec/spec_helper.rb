require 'rubygems'
require 'sidekiq/testing'
require 'capybara/rspec'

if ENV['RAILS_ENV'] == 'test'
  # require 'simplecov'
  # SimpleCov.start 'rails'
  # puts "required simplecov"
end

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  Sidekiq::Testing.fake!  # # fake is the default mode. Fake the sidekiq calls to Redis
  #Capybara.server_port = 53238  # Setting test suite port

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:transaction)
  end

  # Not working with splice enigne
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end


  # makes sure jobs dont linger between tests:
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

end
