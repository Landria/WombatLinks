ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'clearance/testing'
require 'database_cleaner'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def sign_in_user
    sign_in_as FactoryGirl.build(:user)
  end
  
  def sign_in_admin
    sign_in_as FactoryGirl.build(:admin)
  end
  
  def sign_in_as(user)
    @controller.current_user = user
    #session =  Clearance::Session.new(Rails.env)
    #session.current_user = user
    #session.add_cookie_to_headers
    #Clearance::Authentication.new.current_user= user
    #setup_controller_request_and_response
    return user
  end
end

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  def supports_disable_referential_integrity?
    false
  end
end