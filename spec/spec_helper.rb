# encoding: UTF-8
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rspec'
require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'

Capybara.current_driver = :selenium

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation # :progress, :html, :textmate
  config.mock_with :rspec
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Capybara::DSL, type: :integration
  config.include ActionDispatch::TestProcess
  config.before(:each) do
    Resque.redis.flushall
  end

  config.before type: :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
                                    # Request specs cannot use a transaction because Capybara runs in a
                                    # separate thread with a different database connection.
  config.before type: :request do
    DatabaseCleaner.strategy = :truncation
  end
                                    # Reset so other non-request specs don't have to deal with slow truncation.
  config.after type: :request do
    DatabaseCleaner.strategy = :transaction
  end
  config.before do
    DatabaseCleaner.start
    WebMock.disable_net_connect!(:allow_localhost => true)
    ActionMailer::Base.deliveries.clear
  end
  config.after do
    DatabaseCleaner.clean
  end
  Capybara.javascript_driver = :webkit
  Capybara.ignore_hidden_elements = false
end

START_SELENIUM_PORT_DIAPOSON = 1_000
