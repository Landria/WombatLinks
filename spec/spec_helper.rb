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
end

START_SELENIUM_PORT_DIAPOSON = 1_000

def fixture_dir
  "#{Rails.root}/spec/fixtures"
end
