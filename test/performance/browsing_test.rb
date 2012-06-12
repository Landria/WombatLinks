require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }
  def test_homepage
    get '/'
  end

  def test_links_page
    get '/links'
  end

  def test_creating_new_link
    post '/links', :link => { :email => 'underveil@yahoo.com', :link => 'http://rusrails.ru/', :title => '', :description => '', :is_private => false }
  end
  
  def test_creating_new_link_with_title
    post '/links', :link => { :email => 'underveil@yahoo.com', :link => 'http://rusrails.ru/', :title => 'Title', :description => 'Description', :is_private => false }
  end
end
