require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  
  test "config_bitly_login" do
    assert_not_nil APP_CONFIG['bitly_login']
  end
  
  test "config_bitly_login_equal" do
    assert_equal(APP_CONFIG['bitly_login'], 'landria')
  end
  
  test "config_bitly_login_same" do
    assert_same(APP_CONFIG['bitly_login'].class, "landria".class)
  end
end
